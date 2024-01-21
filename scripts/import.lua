setfenv(1, _G.Mod.env)

local select, unpack = select, unpack
local function pack(...) return { n=select("#", ...), ...} end
local function vararg(packed) return unpack(packed, 1, packed.n) end

local import_cache = {}
local init_cache = {} -- This holds the functions that execute their files.

local function ResolvePath(path)
	return MODROOT .. "scripts/" .. path .. ".lua"
end

--- Importer function.
local function import(path)
	path = ResolvePath(path)

	if (import_cache[path]) then
		return vararg(import_cache[path])
	end
	
	local fn = kleiloadlua(path)

	if fn == nil then
		error("[ERR] File does not exist: " .. path)
	elseif type(fn) == "string" then
		error(string.format("[ERR] Error loading file \"%s\".\nError: %s", path, fn))
	else
		setfenv(fn, _G.Mod.env)

		init_cache[path] = fn
		import_cache[path] = pack(fn())
		return vararg(import_cache[path])
	end
end

local function clear_import(path)
	local real_path = ResolvePath(path)

	if import_cache[real_path] then
		import_cache[real_path] = nil
	else
		errorf("Attempt to clear not-loaded import: %q (%q)", path, real_path)
	end
end

local function has_loaded_import(path)
	local real_path = ResolvePath(path)

	return import_cache[real_path] ~= nil
end

local proxy = newproxy(true)
local mt = getmetatable(proxy)
mt.__index = { 
	Clear = clear_import,
	HasLoaded = has_loaded_import,

	_init_cache = init_cache,
	ResolvePath = ResolvePath,
}

mt.__call = function(self, ...)
	return import(...)
end

return proxy