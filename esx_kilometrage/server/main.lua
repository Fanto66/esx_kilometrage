ESX = nil
local minimumkm = 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_kilometrage:addMileage')
AddEventHandler('esx_kilometrage:addMileage', function(vehPlate, km)
    local src = source
    local identifier = ESX.GetPlayerFromId(src).identifier
	local plate = vehPlate
	local newKM = km
	-- print("guardando los km en bbdd")
	-- print(newkm)
	-- print(plate)

    MySQL.Async.execute('UPDATE kilometrage SET km = @kms WHERE carplate = @plate', {['@plate'] = plate, ['@kms'] = newKM})
end)

ESX.RegisterServerCallback('esx_kilometrage:getMileage', function(source, cb, plate)

	local xPlayer = ESX.GetPlayerFromId(source)
	local vehPlate = plate
	-- print("veh plate is:")
	-- print(vehPlate)
	
	-- print("local plate is:")
	-- print(plate)

	MySQL.Async.fetchAll(
		'SELECT * FROM kilometrage WHERE carplate = @plate',
		{
			['@plate'] = vehPlate
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = result[i].carplate

				if vehicleProps == vehPlate then
					KMSend = result[i].km
					-- print("mostrando KMS")
					-- print(KMSend)
					found = true
					break
				end

			end

			if found then
				cb(KMSend)
			else
				cb(0)
				MySQL.Async.execute('INSERT INTO kilometrage (carplate) VALUES (@carplate)',{['@carplate'] = plate})
				Wait(2000)
			end

		end
	)

end)


Citizen.CreateThread(function()
	while true do
		print("cleaned kilometrage")


		MySQL.Async.execute('DELETE FROM kilometrage WHERE km < @minimumkm', {
		['@minimumkm'] = minimumkm
		})
		
		
		Citizen.Wait(100000)

	end
  end)