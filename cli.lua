Obfuscate = require('obfuscator')

if arg[1] == nil then
	io.stderr:write('file required\n')
	os.exit(1)
end

print(Obfuscate(io.open(arg[1], "r"):read("a")))
