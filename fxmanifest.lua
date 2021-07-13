resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
fx_version 'bodacious' --adamant
games {'gta5'}
author 'NLRP'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"configlocal.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"configlocal.lua",
	"client/utils.lua",
	"client/client.lua"
}