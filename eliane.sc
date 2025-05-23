// eliane.sc
// SuperCollider engine for Eliane: modular ARP 2500-style synth for Norns
(
SynthDef("eliane", {
    arg out=0, freq=440, gate=1, cutoff=1000, res=0.5, amp=0.5;

    var vco1, vco2, noise, ringmod, env, filt, vca, lfo;

    vco1 = SinOsc.ar(freq) * 0.5;
    vco2 = Saw.ar(freq * 1.01) * 0.5;
    noise = WhiteNoise.ar(0.3);
    ringmod = vco1 * vco2;

    env = EnvGen.kr(Env.adsr(), gate, doneAction: 2);
    lfo = SinOsc.kr(1).range(0, 1);

    filt = RLPF.ar(vco1 + vco2 + noise, cutoff + (lfo * 200), res);
    vca = filt * env * amp;

    Out.ar(out, [vca, vca]);
}).add;
)
