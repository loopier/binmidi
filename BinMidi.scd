// Use a MIDI piano keyboard in binary form.
//
// Combinations of keypresses represent binary numbers.
// Translate these binary numbers to actions.
// Could be used to set parameters quickly with key combinations.

MIDIClient.init;
MIDIIn.connectAll;
// MIDIFunc.cc({arg ...args; args.postln});

(
~noteOn.free;
~noteOff.free;
// set a range of octaves -- WARNING!: Will throw an error if not in the octave range
~minOctave = 4;
~maxOctave = 6;
// white keys only
~notesPerOctave = 7;
// use binary in normal direction [right to left (<-)] or in reverse more intuitive [left to right (->)]
~reversed = true;
// an array representing a range of the MIDI the keyboard as binary code
~binary = { Array.fill(~notesPerOctave * (~maxOctave - ~minOctave) + 1, 0); }.value;

// translate binary codes to actions
~processBinary = {
	// convert binary to decimal
	var binaryconverter = if(~reversed) {(0..(~binary.size-1))} {(0..(~binary.size-1)).reverse};
	var  num = (~binary * 2.pow(binaryconverter)).sum.asInt;
	num.postln;
};

// translate key presses to binary code
~updatePressedKeys = { |key, value|
	var octave = (key/12).asInt - ~minOctave;
	var degree = key.mod(12);
	// avoid black keys
	var index = Scale.major.degrees.indexOf(degree);
	// index in the binary array to be changed
	var binindex = (octave * ~notesPerOctave) + index;
	~binary[binindex] = value;
	~processBinary.value;

	// ["key: "++key, "degree: "++degree, "octave: "++octave, "index: "++index, "binindex: "++binindex].postln;
};

~noteOn = MIDIFunc.noteOn({ |vel, num, chan, src|
	// postf("note on %\n", [vel, num, chan, src]);
	~updatePressedKeys.value(num, 1);
});

~noteOff = MIDIFunc.noteOff({ |vel, num, chan, src|
	// ("off "++val).postln;
	~updatePressedKeys.value(num, 0);
});
)

