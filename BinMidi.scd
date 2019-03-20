MIDIClient.init;
MIDIIn.connectAll;
// MIDIFunc.cc({arg ...args; args.postln});

(
~noteOn.free;
~noteOff.free;
~pressedKeysDict = Dictionary.newFrom([ Scale.phrygian.degrees, 0].lace(24));
~binary = Array.fill(7, 0);
~isPressed = False;

~toBinary = {
	~pressedKeysDict.keys.asSortedList.do {|key, i|
		// postf("% -> %\n", i, ~pressedKeysDict[key]);
		~binary[~binary.size - 1 - i]  = ~pressedKeysDict[key];
	};
	~isPressed = ~binary.sum > 0;
	~print.value;
};

~print = {
	// ~keys.keys.asSortedList.do{|i| postf("% -> %\n", i, ~keys[i])};
	// ~pressedKeysDict.asSortedArray.postln;
	if (~isPressed) {
		// "pressed".postln;
		~binary.postln;
	} {
		~binary.postln;
		"released".postln;
	}
};

~addPressedKey = { |key| ~pressedKeysDict.put(key, 1); };
~removePressedKey = { |key| ~pressedKeysDict.put(key, 0); };

~noteOn = MIDIFunc.noteOn({ |vel, num, chan, src|
	// postf("note on %\n", [vel, num, chan, src]);
	var octave = (num/12).asInt;
	var degree = (72-num).mod(12);
	// ("on "++degree++" octave: "++octave).postln;
	~addPressedKey.value(degree);
	~toBinary.value;
});

~noteOff = MIDIFunc.noteOff({ |vel, num, chan, src|
	var octave = (num/12).asInt;
	var degree = (72-num).mod(12);
	// ("off "++val).postln;
	~removePressedKey.value(degree);
	~toBinary.value;
});
)



a = 0;
b = "hi";
a.addDependant(b)
a.changed(b)
a.dependants
b = "bye"