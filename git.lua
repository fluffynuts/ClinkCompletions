-- largely copied from https://gist.github.com/sweiss3/9858452
--  - also added path completion for when any text is provided and no branch match is made

function git_checkout_match_generator(text, first, last)
	found_matches = false
    found_branch_match = false
	if rl_state.line_buffer:find("^git checkout ") then
		has_start_branch = not rl_state.line_buffer:find("^git checkout[ ]*$")
		for line in io.popen("git branch 2>nul"):lines() do
			local m = line:match("[%* ] (.+)$")
			if m then
				if not has_start_branch then
					clink.add_match(m)
					found_matches = true
				elseif #text > 0 and m:find(text) then
					clink.add_match(m)
                    found_branch_match = true
					found_matches = true
				end
			end
		end
	end

    if not found_matches or (#text > 0 and not found_branch_match) then
        local where = "."
        if #text > 0 then
            where = text
        end
        local lsresult = ls(where)
        for k,line in pairs(lsresult) do
            if #text > 0 and line:find(text) then
                clink.add_match(line)
                found_matches = true
            elseif #text == 0 then
                clink.add_match(line)
                found_matches = true
            end
        end
    end

    return found_matches
end

clink.register_match_generator(git_checkout_match_generator, 10)
