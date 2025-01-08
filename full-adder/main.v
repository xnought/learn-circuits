
module half_adder(input wire a, input wire b, output wire s, output wire c);
	assign s = a^b;
	assign c = a&b;
endmodule

module full_adder(input wire a, input wire b, input wire i, output wire s, output wire c);

endmodule

module main;
 	reg a;
	reg b;
	reg i;
	wire s; // sum
	wire c; // carry
	integer x,y,z;

	full_adder uut (
		.a(a),
		.b(b),
		.i(i),
		.s(s),
		.c(c)
	);

	initial begin
        $monitor("Time: %0d, a: %b, b: %b, inCarry: %b\nOUTPUTS: s: %b, outCarry: %b\n", $time, a, b, i, s, c);
        for (x = 0; x <= 1; x = x + 1) begin
            for (y = 0; y <= 1; y = y + 1) begin
            	for (z = 0; z <= 1; z = z + 1) begin
					a = x; 
					b = y; 
					i = z;
					#10;   // Wait for 10 time units
				end
            end
        end
        $finish;    
	end
endmodule