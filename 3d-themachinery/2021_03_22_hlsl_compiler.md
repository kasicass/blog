# HLSL Compiler

* [Youtube Video][1]
* 2020-03-20 | HLSL Compiler | Michael Dougherty | DirectX Developer Day
* https://github.com/microsoft/DirectXShaderCompiler

My dxc-playground

* https://github.com/FatGraphicsLab/dxc-playground



## Why DXC?

### FXC - old compiler

* The old shader compiler is deprecated
  * Header: `d3dcompiler.h`
  * Lib: `d3dcompiler.lib`
  * Frontend: `D3DCompiler_47.dll`
  * Intermediate language: `DXBC`
  * Command line: `fxc.exe`
* Supported up to Shader Model 5.1
* Modern drivers convert DXBC to DXIL at runtime


### DXC - new compiler

* The new shader compiler
  * Header: `dxcapi.h`
  * Lib: `dxcompiler.lib`
  * Frontend: `dxcompiler.dll`
  * Intermediate language: `DXIL`
  * Command line: `dxc.exe`
* Supports Shader Model 6.0+
  * Wave intrinsics, 16 bit types, raytracing, variable rate shading, etc.


### DXC is on Github!

Issues lists (bugs)

* https://github.com/microsoft/DirectXShaderCompiler/issues

Documentation (wiki)

* https://github.com/microsoft/DirectXShaderCompiler/wiki
* Shader model details
* Interface and usage notes
* [FXC to DXC port guide][2]

Downloadable releases (faster updates than Windows SDK)

* https://github.com/microsoft/DirectXShaderCompiler/releases/


### Why the changes?

fxc had reached its limits

* Not designed to handle large numbers of large shaders
* Difficult to optimize further
* Difficult to expose console capabilities
* Long compoile times for some shaders

dxc is the path forward

* Based on industry standard Clang/LLVM
* Codebase is easier to modify and improve
* Developed by large team over several years
* Development remains active
* Supports SPIR-V
* Already in use by several major studios and on the Xbox family of Consoles



## Using dxc.exe and dxcompiler.dll

### DXC and dxcompiler.dll design goals

* DXC and dxcompiler.dll are used to build thousands of shaders for retail titles
* We recently updated dxc and the dxcompiler.dll interface (IDxcCompiler3).
  * Command line arguments are now fed directly to the dxcompiler.dll
    interface unifying functionality.
  * PDBs and Reflection data are now far easier to store **separately** from
    your compiled shader (vs. **embedded** in the shader object file).
  * For the interface, the various outputs (both separate and embeded) are
    available immediately after compile.


### Compilation flow

![](images/2021_03_22_hlsl_compiler/dxc-compilation-flow.png)


### Recommended usage

* Compile the shader source from myshader.hlsl and store the
  shader (-Fo) in myshader.dxo
* Generate debug info (-Zi) and store a separate .pdb file (-Fd)
  for debugging later
* Generate separate reflection (-Fre) and don't include it in
  the shader (-Qstrip_reflect)
  * Can be used at asset creation time and then thrown away
  * Results in smaller shader sizes which add up for many shaders

```
> dxc.exe myshader.hlsl
          -Fo myshader.dxo
          -Zi -Fd myshader.pdb
          -Fre "myreflection.ref" -Qstrip_reflect 
```



## Shader Symbols (PDBs)

### Shader symbols

* Shader symbols are used by PIX
  * Shader edit and continue
    * Modify HLSL
    * Change compiler arguments (e.g. -O3 to -Od)
  * Shader debugging
  * Auto-formatting of buffers
  * Resource names


### Shader symbols goals

* Our goal: Make HLSL symbols as seamless as C++ symbols
  * DXC generates standalone pdbs by default
  * PIX searches for pdbs upon capture/open
  * PIX embeds pdbs in the capture file upon save


### Shader symbols with dxc

* Generating and stripping pdbs to a file
* -Zi
  * Generate pdbs, but don't "embed" them in the shader
* -Fd [filename.pdb]
  * Save to [filename.pdb]
* -Fd [foldername]\ or -Fd [foldername]/
  * Save to [foldername]\[**shaderhash**].pdb
* -Qembed_debug
  * Legacy behavior, not recommended


### Reflection

* The reflection API defined in d3d12shader.h is wholly contained as part
  of the compiler. The DirectX runtime is not needed.
* You may get different reflection resource usages based depending on whether
  you use -Od or not.
* -Fre [filename.ref]
  * Save reflection to [filename.ref]
* -Qstrip_reflect
  * Used to strip reflection from shader.
  * "Embedded" reflection is still the default in order to match existing
    asset pipelines.



## Interface walkthrough

### Using Dxcompiler.dll - arguments

```C++
// Pass the same arguments as you would to the command line, as text!
std::vector<LPCWSTR> arguments;

// entrypoint
arguments.push_back(L"-E");
arguments.push_back(L"main");

// shader model
arguments.push_back(L"-T");
argumenes.push_back(L"ps_6_0");

// Generate symbols
arguments.push_back(L"-Zi");
arguments.push_back(L"-Fd");
arguments.push_back(pdbPath);

// Generate reflection
arguments.push_back(L"-Qstrip_reflect");
arguments.push_back(L"-Fre");
arguments.push_back(L"refPath");

// defines
arguments.push_back(L"-D");
arguments.push_back(L"MY_DEFINE=1");
```


### Using Dxcompiler.dll - compile

```C++
ComPtr<IDxcUtils> utils;
hr = DxcCreateInstance(CLSID_DxcUtils, IID_PPV_ARGS(utils.ReleaseAndGetAddressOf()));

ComPtr<IDxcIncludeHandler> includeHandler;
utils->CreateDefaultIncludeHandler(includeHandler.ReleaseAndGetAddressOf());

ComPtr<IDxcCompiler3> compiler3;
hr = DxcCreateInstance(CLSID_DxcCompiler, IDD_PPV_ARGS(&compiler3));

ComPtr<IDxcResult> result;
hr = compiler3->Compile(&source,
        arguments.data(),
        (UINT32)arguments.size(),
        includeHandler.Get(),
        IID_PPV_ARGS(&result));
```


### Using Dxcompiler.dll - outcome of compile

```C++
// For use with IDxcResult::[Has|Get]Output dxcOutKind argument
// Note: text outputs returned from version 2 APIs are UTF-8 or UTF-16 based on -encoding option
typedef enum DXC_OUT_KIND {
    DXC_OUT_NONE = 0,
    DXC_OUT_OBJECT = 1,         // IDxcBlob - Shader or library object
    DXC_OUT_ERRORS = 2,         // IDxcBlobUtf8 or IDxcBlobUtf16
    DXC_OUT_PDB = 3,            // IDxcBlob
    DXC_OUT_SHADER_HASH = 4,    // IDxcBlob - DxcShaderHash of shader or shader with source info (-Zsb/-Zss)
    DXC_OUT_DISASSEMBLY = 5,    // IDxcBlobUtf8 or IDxcBlobUtf16 - from Disassemble
    DXC_OUT_HLSL = 6,           // IDxcBlobUtf8 or IDxcBlobUtf16 - from Preprocessor or Rewriter
    DXC_OUT_TEXT = 7,           // IDxcBlobUtf8 or IDxcBlobUtf16 - other text, such as -ast-dump or -Odump
    DXC_OUT_REFLECTION = 8,     // IDxcBlob - RDAT part with reflection data
    DXC_OUT_ROOT_SIGNATURE = 9, // IDxcBlob - Serialized root signature output
    DXC_OUT_EXTRA_OUTPUTS  = 10,// IDxcExtraResults - Extra outputs

    DXC_OUT_FORCE_DWORD = 0xFFFFFFFF
} DXC_OUT_KIND;


result->GetStats(&hr);

// Assumes default utf8 encoding, use IDxcUtf16 with -encoding utf16
ComPtr<IDxcBlobUtf8> errorMsgs;
result->GetOutput(DXC_OUT_ERRORS, IID_PPV_ARGS(&errorMsgs), nullpgtr);

if (errorMsgs && errorMsgs->GetStringLength()) {
    MyPrintMessage("Compile returned HRESULT (0x%x), errors/warnings:\n\n %s\n",
        hr, errorMsgs->GetStringPointer());
}

if (FAILED(hr)) {
    return hr;
}
```


### Using Dxcompiler.dll - object

```C++
ComPtr<IDxcBlob> shaderobj;
hr = result->GetOutput(DXC_OUT_OBJECT, IID_PPV_ARGS(&shaderobject), nullptr);
hr = MyWriteBlobToFile(shaderobj.Get(), filename, TRUE);
```


### Using Dxcompiler.dll - symbols

```C++
ComPtr<IDxcBlob> pdbData;
ComPtr<IDxcBlobUtf16> pdbPathFromCompiler;

hr = result->GetOutput(DXC_OUT_PDB,
    IID_PPV_ARGS(&pdbData),
    &pdbPathFromCompiler);

// Now write the contents of pdbData to a file at pdbPathFromCompiler
hr = MyWriteBlobToFile(pdbData.Get(),
    pdbPathFromCompiler->GetStringPointer(),
    TRUE);
```


### Using Dxcompiler.dll - reflection

```C++
ComPtr<IDxcBlob> reflection;
hr = result->GetOutput(DXC_OUT_REFLECTION,
    IID_PPV_ARGS(&reflection),
    nullptr);

DxcBuffer reflectionData = {
    reflection->GetBufferPointer(),
    reflection->GetBufferSize(),
    0U,
};
ComPtr<ID3D12ShaderReflection> D3D12Reflection;
hr = utils->CreateReflection(&reflectionData,
    IID_PPV_ARGS(&D3D12Reflection));
```



## Tips!

### "Stripped" data

* Stripping flags refere only to /Fo output (DXC_OUT_OBJECT)
  * `-Qstrip_debug`, strip debug information from 4_0+ shader bytecode
  * `-Qstrip_priv`, strip private data from shader bytecode
  * `-Qstrip_reflect`, strip reflection data from shader bytecode
  * `-Qstrip_rootsignature`, strip root signature data from shader bytecode
* Stripped data is still available (as in preceding example)
  * `arguments.push_back(L"-Qstrip_reflect");`
  * `GetOutput(DXC_OUT_REFLECTION, ...);`
* Strip everything; retrieve what you need


### Multithreading

* The call to DxcCreateInstance is thread-safe, **but objects created by DxcCreateInstance aren't thread-safe.**
* Compiler objects should be create and then used on the same thread

Do

* Create a single compiler object for each thread
* Use a separate include handler for each thread or make sure your include handler is thread-safe

Don't

* Create one compiler instance and use it for multiple threads

See: https://github.com/microsoft/DirectXShaderCompiler/wiki/Using-dxc.exe-and-dxcompiler.dll



## Language and features roadmap

### Roadmap (short term)

* There will be a Shader Model 6.6 but we are not ready to share what is in it yet.
* The size of the reflection data will be reduced *dramatically*.
* Interface: Advanced inputs such as root signatures will be made available
  via the include handler
* Language
  * Bitfields
  * offsetof and more complete support for sizeof



[1]:https://www.youtube.com/watch?v=tyyKeTsdtmo
[2]:https://github.com/microsoft/DirectXShaderCompiler/wiki/Porting-shaders-from-FXC-to-DXC
