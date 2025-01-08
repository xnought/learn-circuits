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

module adder #(parameter WIDTH = 8) (
	input wire [WIDTH-1:0] a,
	input wire [WIDTH-1:0] b,
	output wire [WIDTH-1:0] sum,
	output wire overflow
);
	wire [WIDTH-1:0] adder_carries;
	half_adder ha (
		.a(a[0]),
		.b(b[0]),
		.sum(sum[0]),
		.carry(adder_carries[0])
	);

	genvar i;
	generate
		for(i = 1; i < WIDTH; i = i + 1) begin: adder_loop
			full_adder fa (
				.a(a[i]),
				.b(b[i]),
				.in_carry(adder_carries[i-1]),
				.sum(sum[i]),
				.out_carry(adder_carries[i])
			);
		end
	endgenerate

	assign overflow = adder_carries[WIDTH-1];
endmodule

module main;
 	reg [5:0] a;
	reg [5:0] b;
	wire [5:0] sum;
	wire overflow; 

 
	adder #(.WIDTH(6)) uut (
		.a(a),
		.b(b),
		.sum(sum),
		.overflow(overflow)
	);

	initial begin
        $monitor("[Time: %0d]\t%b + %b = %b\t(overflow=%b)\n", $time, a, b, sum, overflow);
		a = 6'b000000; b = 6'b000001; #10;
		a = 6'b000001; b = 6'b000101; #10;
		a = 6'b111111; b = 6'b111111; #10;
        $finish;    
	end
endmodule