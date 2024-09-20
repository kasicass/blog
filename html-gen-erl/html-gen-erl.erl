%% -*- erlang -*-

-define(URL_PREFIX, "https://github.com/kasicass/blog/blob/master/").
-define(OUTPUT_FILE, "../../kasicass.github.io/index-erl.html").

main(_) ->
    Files     = get_markdown_files(),
    TagFiles1 = gen_tag_files(Files),
    TagFiles2 = gen_minibook(TagFiles1),
    TagUrls   = gen_tag_urls(TagFiles2, none_tag, []),
    Html      = gen_html(TagUrls),
    output_to_file(Html).

get_markdown_files() ->
    Wildcard = "../*/*.md",
    Files = filelib:wildcard(Wildcard),
    %% no need for this, as no .md files in [html-gen].
    %% lists:filter(fun(X) -> string:find(X, "html-gen") == nomatch end, Files).
    Files.

%% "../os-freebsd/2018_09_23_name.md" => {"os-freebsd", "2018_09_23_name.md"}
%% Files => [{tag, file}, {"os-freebsd", "2018_09_23_name.md"}, ...]
gen_tag_files(Files) ->
    TagFiles1 = lists:map(fun (File) ->
            [_, Tag, Name] = string:split(File, "/", all),
            {Tag, Name}
        end,
        Files
    ),
    TagFiles1.

%% make [minibook] come first
gen_minibook(TagFiles1) ->
    TagFiles2 = lists:sort(fun (X) ->
            {Tag, _} = X,
            Tag == "minibook"
        end,
        TagFiles1
    ),
    TagFiles2.

%% [{"<h2>os-freebsd</h2>", "<li>2014_09_23_name.md</li>"}, ...]
gen_tag_urls([], _, Result) ->
    lists:reverse(["</ul>" | Result]);
gen_tag_urls([H|L], none_tag, Result) ->
    {Tag1, MdName} = H,
    Li = mdname_to_li(Tag1, MdName),
    gen_tag_urls(L, Tag1, [ Li | ["<ul>" | ["<h2>" ++ Tag1 ++ "</h2>" | Result]]]);
gen_tag_urls([H|L], Tag, Result) ->
    {Tag1, MdName} = H,
    Li = mdname_to_li(Tag1, MdName),
    case Tag1 /= Tag of
        true ->
            gen_tag_urls(L, Tag1, [Li | ["<ul>" | ["<h2>" ++ Tag1 ++ "</h2>" | ["</ul>" | Result]]]]);
        _ ->
            gen_tag_urls(L, Tag, [Li | Result])
    end.

%% markdown name to name
mdname_to_li(Tag, MdName) ->
    Name1 = string:replace(MdName, "_", " ", all),
    Name2 = string:slice(Name1, 0, string:length(Name1) - 3),
    Li = "<li><a href=\"" ++ ?URL_PREFIX ++ Tag ++ "/" ++ MdName ++ "\">" ++ Name2 ++ "</a></li>",
    Li.

%% Generate HTML content.
gen_html(TagUrls) ->
    Body = lists:concat(lists:join("\r\n", TagUrls)),
    """
<html>
<head>
<meta charset="utf-8">
</head>
<body>
<h1>kasicass' blog</h1>

""" ++ Body ++ """

</body>
</html>

""".

%% Output HTML to file.
output_to_file(Html) ->
    {ok, Fd} = file:open(?OUTPUT_FILE, [write]),
    file:write(Fd, Html),
    file:close(Fd).
