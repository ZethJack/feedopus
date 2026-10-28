# feedopus-tldr-wrapper
# This tldr client reads ~/.cache/tldr and drops those files on `tldr -k`.
# Pages kept in ~/.local/share/tldr are copied back before each lookup.
function tldr --description "tldr, including pages in ~/.local/share/tldr"
    set -l cache $HOME/.cache
    if set -q XDG_CACHE_HOME; and test -n "$XDG_CACHE_HOME"
        set cache $XDG_CACHE_HOME
    end
    set -l src_root $HOME/.local/share/tldr/pages
    if set -q XDG_DATA_HOME; and test -n "$XDG_DATA_HOME"
        set src_root $XDG_DATA_HOME/tldr/pages
    end
    if test -d $src_root
        for page in $src_root/*/*.md
            set -l rel (string replace -- "$src_root/" "" $page)
            set -l dest $cache/tldr/pages/$rel
            mkdir -p (dirname $dest)
            cp $page $dest
        end
    end
    command tldr $argv
end
