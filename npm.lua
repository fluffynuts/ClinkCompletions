local Npm = {}
Npm.get_npm_scripts = function()
    local packageJson = find_file_upward('package.json')
    if packageJson == nil then
        return { }
    end
    local file = io.open(packageJson, "r")
    local lines = split(file:read("*a"), "\n")
    file.close()
    local i = 1
    local j = 1
    local result = {""}
    local line = lines[i]
    local in_scripts_section = false
    while line ~= nil do
        local parts = split(line, ":")
        local first_part = trim(parts[1])
        if first_part == "\"scripts\"" then
            in_scripts_section = true
        elseif first_part == "}," and in_scripts_section then
            in_scripts_section = false
        elseif in_scripts_section then
            thisOne = (first_part:gsub("\"", ""))
            result[j] = thisOne
            j = j + 1
        end
        i = i + 1
        line = lines[i]
    end
    return result
end
Npm.npm_parser = clink.arg.new_parser()
Npm.all_args = {
    "run", "run-script", "help",
    "access", "adduser", "bin", "bugs", "c", "cache", "completion", "config",
    "ddp", "dedupe", "deprecate", "dist-tag", "docs", "edit", "explore", "get",
    "help-search", "i", "init", "install", "install-test", "it", "link",
    "list", "ln", "logout", "ls", "outdated", "owner", "pack", "ping", "prefix",
    "prune", "publish", "rb", "rebuild", "repo", "restart", "root",
    "s", "se", "search", "set", "shrinkwrap", "star", "stars",
    "start", "stop", "t", "tag", "team", "test", "tst", "un", "uninstall",
    "unpublish", "unstar", "up", "update", "v", "version", "view", "whoami"
}
Npm.run_parser = clink.arg.new_parser():set_arguments({"run"}, {Npm.get_npm_scripts})
Npm.help_parser = clink.arg.new_parser():set_arguments({"help"}, Npm.all_args)
Npm.allargs_parser = clink.arg.new_parser():set_arguments(Npm.all_args, {})
clink.arg.register_parser("npm", Npm.allargs_parser)
clink.arg.register_parser("npm", Npm.run_parser)
clink.arg.register_parser("npm", Npm.help_parser)

