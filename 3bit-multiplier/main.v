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

module mult3 (
	input wire [2:0] a,
	input wire [2:0] b,
	output wire [2:0] product,
	output wire overflow
);
	// First compute the terms in the partial sum / the intermediate multiplication
	wire [2:0] t0;
	assign t0[0] = b[0]&a[0];
	assign t0[1] = b[0]&a[1];
	assign t0[2] = b[0]&a[2];
	// Second, compute second intermediate term 
	wire [1:0] t1;
	assign t1[0] = b[1]&a[0];
	assign t1[1] = b[1]&a[1];
	// Then the final term
	wire t2;
	assign t2 = b[2]&a[0];


	// !CHECKPOINT!
	// Okay, now I have all the itermediate terms. Now I need to add them all up to get the result.

	// first product[0] = t0[0] RIGHT MOST BIT
	assign product[0] = t0[0]; 

	// then add product[1] = t0[1] + t1[0], bring the carry to the next computation
	wire ha_carry;
	half_adder ha (
		.a(t0[1]),
		.b(t1[0]),
		.sum(product[1]),
		.carry(ha_carry)
	);

	// then add product[2] = t0[2] + t1[1] + t2
	wire fa0_sum;
	wire fa0_carry;
	full_adder fa0 (
		.a(t0[2]),
		.b(t1[1]),
		.in_carry(ha_carry),
		.sum(fa0_sum),
		.out_carry(fa0_carry)
	);
	// then add t2 to that result as the product and out as overflow
	full_adder fa1 (
		.a(fa0_sum),
		.b(t2),
		.in_carry(fa0_carry),
		.sum(product[2]),
		.out_carry(overflow)
	);
endmodule

module main;
 	reg [2:0] a;
	reg [2:0] b;
	wire [2:0] product;
	wire overflow; 
 
	mult3 uut (
		.a(a),
		.b(b),
		.product(product),
		.overflow(overflow)
	);

	initial begin
        $monitor("[Time: %0d]\t%b * %b = %b\t(overflow=%b)\n", $time, a, b, product, overflow);
		a = 3'b011; b = 3'b010; #10; // 3 * 2 = 6
        $finish;    
	end
endmodule