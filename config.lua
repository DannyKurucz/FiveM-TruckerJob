cfg = {
    
    esxLegacy = true,

    translation = {
        ['blipName'] = 'Truck deop',
        ['gpsRoute'] = 'You have your route on GPS. deliver the shipment in order.',
        ['takeMoney'] = 'As a deposit for renting a truck, we took $ 1,000 from you.',
        ['alreadyOut'] = 'You ve already pulled out your truck',
        ['unhookTrailer'] = 'Unhook the semi-trailer with [E] ',
        ['returnVeh'] = 'Return vehicle with [E]',
        ['buyCargo'] = 'You brought the cargo',
        ['goBack'] = 'Go back to the depot to drop off the truck',
        ['returnMoney'] = 'Thank you, your deposit has been returned',
        ['mustTrailer'] = 'You must also have a trailer',
        ['returnTruck'] = 'You have to bring us the car we lent you',
        ['startRoute'] = 'Start the route with [E]',
        ['jobblip'] = 'Depo',

    },

    job = {
        ['job'] = "truck"
    },

    blip = {
        ['blip'] = vector3(1203.5892, -3103.6331, 5.8028) 
    }

}


Notify = function(msg)
    ESX.ShowNotification(msg)
 --   exports.ox_inventory:notify({text = msg, duration = 5000, position = 'bottom-center'})
end
