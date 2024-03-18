---@param s string
---@param start integer
function IndexOfNextUnescapedQuote(s, start)
	for i = start + 1, #s do
		local curr = s:sub(i, i)
		local prev = s:sub(i - 1, i - 1)
		if (curr == '"' or curr == "'") and prev ~= '\\' then
			return i
		end
		i = i + 1
	end
	return nil
end

DontObfuscate = {
	-- Lua keywords
	["and"] = true,
	["break"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
	["while"] = true,

	-- Lua metamethods
	["__add"] = true,
	["__sub"] = true,
	["__mul"] = true,
	["__div"] = true,
	["__mod"] = true,
	["__pow"] = true,
	["__unm"] = true,
	["__idiv"] = true,
	["__band"] = true,
	["__bor"] = true,
	["__bxor"] = true,
	["__bnot"] = true,
	["__shl"] = true,
	["__shr"] = true,
	["__concat"] = true,
	["__len"] = true,
	["__eq"] = true,
	["__lt"] = true,
	["__le"] = true,
	["__index"] = true,
	["__newindex"] = true,
	["__call"] = true,
	["__tostring"] = true,
	["__metatable"] = true,
	["__gc"] = true,
	["__mode"] = true,
	["__close"] = true,

	-- Lua libraries
	["_G"] = true,
	["_VERSION"] = true,
	["assert"] = true,
	["collectgarbage"] = true,
	["dofile"] = true,
	["error"] = true,
	["getmetatable"] = true,
	["ipairs"] = true,
	["load"] = true,
	["loadfile"] = true,
	["next"] = true,
	["pairs"] = true,
	["pcall"] = true,
	["print"] = true,
	["rawequal"] = true,
	["rawget"] = true,
	["rawlen"] = true,
	["rawset"] = true,
	["require"] = true,
	["select"] = true,
	["setmetatable"] = true,
	["tonumber"] = true,
	["tostring"] = true,
	["type"] = true,
	["unpack"] = true,
	["xpcall"] = true,

	-- Standard libraries
	["coroutine"] = true,
	["debug"] = true,
	["file"] = true,
	["io"] = true,
	["math"] = true,
	["os"] = true,
	["package"] = true,
	["string"] = true,
	["table"] = true,
}

---@param code string
function Obfuscate(code)
	local i = 1
	local obfuscated_code = ''
	local obf_index = 0
	local identifiers = {}

	while i <= #code do
		local c = code:sub(i, i)

		if c:match("['\"]") then
			local j = IndexOfNextUnescapedQuote(code, i)

			if not j then
				io.stderr:write('no closing quote found!\n')
				os.exit(1)
			end

			obfuscated_code = obfuscated_code .. code:sub(i, j)
			i = j + 1

			goto continue
		end

		local identifier = code:match('^(%a[%w_]*)[^%w_]', i)

		if identifier then
			local obf_identfier

			if DontObfuscate[identifier] then
				obf_identfier = identifier
			else
				if not identifiers[identifier] then
					identifiers[identifier] = '_' .. obf_index
					obf_index = obf_index + 1
				end
				obf_identfier = identifiers[identifier]
			end

			obfuscated_code = obfuscated_code .. obf_identfier
			obf_index = obf_index + 1

			i = i + #identifier
			goto continue
		end

		obfuscated_code = obfuscated_code .. c
		i = i + 1

		::continue::
	end

	return obfuscated_code
end

return Obfuscate
