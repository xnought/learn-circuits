module half_adder(input wire a, input wire b, output wire sum, output wire carry);
	assign sum = a^b;
	assign carry = a&b;
endmodule

// https://i.sstatic.net/E0itr.png
module full_adder(input wire a, input wire b, input wire in_carry, output wire sum, output wire out_carry);
	wire first_add;
	wire [1:0] half_adder_carries;

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

// Add 2 numbers 4 bits each and result is 4 bits. If goes over, overflow bit 1. Otherwise 0.
module adder4(
	input wire [3:0] a,
	input wire [3:0] b,
	output wire [3:0] sum,
	output wire overflow
);
	wire [2:0] adder_carries;
	half_adder bit0 (
		.a(a[0]),
		.b(b[0]),
		.sum(sum[0]),
		.carry(adder_carries[0])
	);
	full_adder bit1 (
		.a(a[1]),
		.b(b[1]),
		.in_carry(adder_carries[0]),
		.sum(sum[1]),
		.out_carry(adder_carries[1])
	);
	full_adder bit2 (
		.a(a[2]),
		.b(b[2]),
		.in_carry(adder_carries[1]),
		.sum(sum[2]),
		.out_carry(adder_carries[2])
	);
	full_adder bit3 (
		.a(a[3]),
		.b(b[3]),
		.in_carry(adder_carries[2]),
		.sum(sum[3]),
		.out_carry(overflow)
	);
endmodule

module main;
 	reg [3:0] a;
	reg [3:0] b;
	wire [3:0] sum;
	wire overflow; 

	adder4 uut (
		.a(a),
		.b(b),
		.sum(sum),
		.overflow(overflow)
	);

	initial begin
        $monitor("[Time: %0d] %b + %b = %b\t(overflow=%b)\n", $time, a, b, sum, overflow);
		a = 4'b0000; b = 4'b0001; #10;
		a = 4'b1010; b = 4'b0001; #10;
		a = 4'b0100; b = 4'b0100; #10;
		a = 4'b1111; b = 4'b1111; #10;
        $finish;    
	end
endmodule