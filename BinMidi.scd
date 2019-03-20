MIDIClient.init;
MIDIIn.connectAll;
// MIDIFunc.cc({arg ...args; args.postln});

(
~noteOn.free;
~noteOff.free;
~binary = Array.fill(71, 0);

~updatePressedKeys = { |key, value|
	var octave = (key/12).asInt;
	var degree = key.mod(12);
	// avoid black keys
	var index = Scale.major.degrees.indexOf(degree);
	// index in the binary array to be changed
	var binindex = (octave * Scale.major.degrees.size) + index;
	var bin ;
	~binary[binindex] = value;
	bin = (~binary * 2.pow((0..70).reverse)).sum.asInt;

	["key: "++key, "degree: "++degree, "octave: "++octave, "index: "++index, "binindex: "++binindex, "bin: "++bin].postln;
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

