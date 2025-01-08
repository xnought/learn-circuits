module half_adder(input wire a, input wire b, output wire s, output wire c);
	assign s = a^b;
	assign c = a&b;
endmodule

module main;
 	reg a;
	reg b;
	wire s; // sum
	wire c; // carry
	integer i, j;

	half_adder uut (
		.a(a),
		.b(b),
		.s(s),
		.c(c)
	);

	initial begin
        $monitor("Time: %0d, a: %b, b: %b, s: %b, c: %b", $time, a, b, s, c);
        for (i = 0; i <= 1; i = i + 1) begin
        	for (j = 0; j <= 1; j = j + 1) begin
				a = i;
				b = j;
				#10;
			end
		end
        $finish;    
	end
endmodule