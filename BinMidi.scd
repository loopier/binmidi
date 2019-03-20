MIDIClient.init;
MIDIIn.connectAll;
// MIDIFunc.cc({arg ...args; args.postln});

(
~noteOn.free;
~noteOff.free;
~binary = Array.fill2D(11, 7, 0);

// Returns the index of the degree in a scale
~getDegreeIndex = {|degree, scale|
	var index;
	if (scale == nil) { scale = Scale.phrygian };
	scale.degrees.do {
		|item, i|
		if (item==degree) { index = scale.size - 1 - i };
	};
	index;
};

~updatePressedKeys = { |key, value|
	var octave = ((key-1)/12).asInt;
	var degree = (12-key).mod(12);
	// get index in binary array from degree
	var index = ~getDegreeIndex.value(degree);
	~binary[octave][index] = value;
	// postf("oct: %  deg: %  val: %  index: %\n", octave, degree, value, index);
	// ~binary.do { |item, i| postf("%: %\n", i, item.postln); };
	postf("% -- %\n", octave, ~binary[octave]);
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

[[1,0],[1,0]].sum