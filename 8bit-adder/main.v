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

module adder8(
	input wire [7:0] a,
	input wire [7:0] b,
	output wire [7:0] sum,
	output wire overflow
);
	wire [7:0] adder_carries;
	half_adder ha (
		.a(a[0]),
		.b(b[0]),
		.sum(sum[0]),
		.carry(adder_carries[0])
	);

	genvar i;
	generate
		for(i = 1; i <= 7; i = i + 1) begin: adder_loop
			full_adder fa (
				.a(a[i]),
				.b(b[i]),
				.in_carry(adder_carries[i-1]),
				.sum(sum[i]),
				.out_carry(adder_carries[i])
			);
		end
	endgenerate

	assign overflow = adder_carries[7];
endmodule

module main;
 	reg [7:0] a;
	reg [7:0] b;
	wire [7:0] sum;
	wire overflow; 

	adder8 uut (
		.a(a),
		.b(b),
		.sum(sum),
		.overflow(overflow)
	);

	initial begin
        $monitor("[Time: %0d]\t%b + %b = %b\t(overflow=%b)\n", $time, a, b, sum, overflow);
		a = 8'b00000000; b = 8'b00000001; #10;
		a = 8'b00001000; b = 8'b00100001; #10;
		a = 8'b11111111; b = 8'b11111111; #10;
        $finish;    
	end
endmodule