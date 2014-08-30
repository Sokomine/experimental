
Procedure for testing:
1. /giveme experimental:inv_move_demo
2. Place the demo object somewhere (looks like a chest with a ladder)
3. Right-click the demo-object.
4. Take a stack out of one of the inventory slots of the demo-object and put it
   into an *empty* receiving slot in your player-inventory.

Expected result:    stack removed from demo-object and moved into your inventory;
                    allow_metadata_inventory_take is called and ALLOWS the move
Observed behaviour: OK - works as expected
With patch:         OK - works as expected
	

5. Try to take a stack from your inventory and put it into an *empty* slot of the demo object.

Expected result:    move denied
                    stack will appear back in your inventory
                    allow_metadata_inventory_put is called and DENIES the move
Observed behaviour: OK
With patch:         OK

6. Try to take a stack out of the demo-object and place it on a slot in your player
   inventory that *already contains* a diffrent stack.

Expected result:    move denied - the destination inventory slot is occupied, and the output slot
                    of the demo object does not want any input
Observed behaviour: allow_metadata_inventory_take is called and allows taking the stack out of the demo-object;
                    The stack in the receiving slot never appears as a parameter in any api call.
                    The stack in the receiving slot is PUT (swpapped) into the output-only-slot of the demo object.
                    The demo object does not receive any information at all about the new stack in its output-only-slot. 
With patch:         OK

So far, so good. Bug fixed. But: An undesired side-effect shows up which is bad for gameplay:

7. Place a normal chest. (default:chest)
8. Put a stack of something into the chest.
9. As in 6., take the stack back out of the chest and try to place it in a slot of your inventory that already contains
   a diffrent stack.

Expected result:    The stack out of the chest is placed into your inventory slot.
                    The stack that occupied your inventory slot before is placed in the chest.
Observed behaviour: OK - The old stack from your inventory gets put into the chest, and the new stack will stick to your mouse,
                    ready to be put into the - now empty - slot in your inventory.
With patch:         Move denied.
                    

Possible solution:
Extend allow_metadata_inventory_take = function(pos, listname, index, stack, player)
by adding a new parameter that provides information about the RECEIVING slot:
allow_metadata_inventory_take = function(pos, listname, index, stack, player, will_swap )
If the destination inventory cannot (fully) take the stack, will_swap is true. Else false.
