cd ..\..\kasicass.github.io
git pull
cd ..\blog\html-gen
escript html-gen-erl.erl
cd ..\..\kasicass.github.io
git commit -a -m "update"
git push
cd ..\blog\html-gen
