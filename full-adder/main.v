
module half_adder(input wire a, input wire b, output wire s, output wire c);
	assign s = a^b;
	assign c = a&b;
endmodule

// module full_adder(input wire a, input wire b, input wire i, output wire s, output wire c)
	
// endmodule

module main;
 	reg a;
	reg b;
	reg i;
	wire s; // sum
	wire c; // carry

	full_adder uut (
		.a(a),
		.b(b),
		.i(i)
		.s(s),
		.c(c)
	);

	initial begin
        $monitor("Time: %0d, a: %b, b: %b, inCarry: %b, s: %b, outCarry: %b", $time, a, b, i, s, c);
        for (i = 0; i <= 1; i = i + 1) begin
            for (j = 0; j <= 1; j = j + 1) begin
            	for (k = 0; k <= 1; k = k + 1) begin
					a = i; 
					b = j; 
					i = k;
					#10;   // Wait for 10 time units
				end
            end
        end
        $finish;    
	end
endmodule