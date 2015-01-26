module blackbox(j, g, v, y);
    output j;
    input  g, v, y;
    wire   w00, w01, w02, w03, w08, w10, w19, w24, w31, w32, w42, w64, w65, w66, w72, w75, w76, w80, w92, w99;

    or  o23(j, w42, w72, w02);
    and a61(w72, w76, w92);
    not n98(w92, w76);
    and a18(w02, w66, w19);
    not n83(w66, w19);
    and a7(w76, w03, w31);
    not n5(w03, y);
    or  o96(w31, g, w65);
    and a4(w65, v, w24);
    not n30(w24, g);
    or  o91(w19, w75, w80);
    and a16(w75, w64, w32);
    not n11(w64, v);
    not n21(w32, y);
    and a79(w80, w01, v, w08);
    not n56(w01, g);
    not n85(w08, y);
    and a49(w42, v, w99);
    or  o81(w99, g, w00);
    and a14(w00, y, w10);
    not n13(w10, y);

endmodule // blackbox
