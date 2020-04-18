-- The structure of a speech entry;
--	- texture - the portrait texture, representing the speaker
--  - display_name - the name displayed below the portrait
--	- content - the actual line that the character will 'say'
--	- choices (optional) - does the player have any choices to respond to this part of conversation
--	  = text - the text of the choice
--	  = next - the next conversation node to get to when this choice is selected
--	- next - the index of the next speech data in this table, nil if that's the end of the speech sequence

local speech_content = {
	FLAT_PHONE_CALL_1 = {
		id = "FLAT_PHONE_CALL_1",
		texture = "23 Zombie Knight",
		display_name = "Doctor",
		content = "We need you.To keep patient alive",
		choices = {
			{ text = "Ok" },
			{ text = "Go" },
		},
		next = nil
	},

}

return speech_content