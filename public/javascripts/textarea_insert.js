
function insertTextIntoTextarea(txtarea, textToInsert) {
	var CaretPos = 0;

	// IE Support
	if (document.selection) {
		txtarea.focus();
		var selection = document.selection.createRange();
			alert(selection.text);
		selection.text = textToInsert;

		var duplicateSelection = selection.duplicate();

		duplicateSelection.moveToElementText(txtarea);

		var CaretPos = -1;
		while(duplicateSelection.inRange(selection)) {
			duplicateSelection.moveStart('character');
			alert(duplicateSelection.text);

			CaretPos++;
		}
	}

	// Firefox support
	else if (txtarea.selectionStart || txtarea.selectionStart == 0) {
		var startPos 	= txtarea.selectionStart;
		var backPos 	= txtarea.selectionEnd; 
		var front 		= (txtarea.value).substring(0,startPos); 
		var back 		= (txtarea.value).substring(backPos,txtarea.value.length); 

		// Replace textarea text with new value
		txtarea.value 	= front + textToInsert + back; 

		// Place caret at correct position
		caretPosition = calculateCaretPosition(startPos, textToInsert);
		txtarea.focus();
		txtarea.setSelectionRange(caretPosition,caretPosition);
	}
}

function calculateCaretPosition(startPosition, insertedText) { // FF
	caretPosition = startPosition + insertedText.length
	return(caretPosition)
}
