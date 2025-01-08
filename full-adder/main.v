
module half_adder(input wire a, input wire b, output wire sum, output wire carry);
	assign sum = a^b;
	assign carry = a&b;
endmodule

// https://i.sstatic.net/E0itr.png
module full_adder(input wire a, input wire b, input wire in_carry, output wire sum, output wire out_carry);
	wire first_add;
	wire half_adder_carries[1:0];

	half_adder ha0 ( 
		.a(a),
		.b(b),
		.sum(first_add),
		.carry(half_adder_carries[0])
	);
	half_adder ha1 (
		.a(first_add),
		.b(in_carry),
		.sum(sum),
		.carry(half_adder_carries[1])
	);
	assign out_carry = half_adder_carries[0]|half_adder_carries[1];
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
		.in_carry(i),
		.sum(s),
		.out_carry(c)
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