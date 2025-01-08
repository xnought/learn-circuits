module half_adder(input wire a, input wire b, output wire s, output wire c);
	assign s = a^b;
	assign c = a&b;
endmodule

module main;
 	reg a;
	reg b;
	wire s; // sum
	wire c; // carry

	half_adder uut (
		.a(a),
		.b(b),
		.s(s),
		.c(c)
	);

	initial begin
        $monitor("Time: %0d, a: %b, b: %b, s: %b, c: %b", $time, a, b, s, c);
        a = 0; b = 0; #10;  
        a = 0; b = 1; #10; 
        a = 1; b = 0; #10;  
        a = 1; b = 1; #10;  
        $finish;    
	end
endmodule