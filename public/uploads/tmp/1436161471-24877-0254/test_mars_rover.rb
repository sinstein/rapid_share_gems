require "minitest/autorun"
require "./mars_rover.rb"

class TestRover < Minitest::Test
	
	def setup
		@rover = Rover.new(0,0,0)
		@grid = Grid.new(5,5)
	end

	def test_grid_limits
		assert_equal 5,@grid.grid_x
		assert_equal 5,@grid.grid_y
	end

	def test_direction 
		assert_equal "W", @rover.move('L',@grid)
		assert_equal "N", @rover.move('R',@grid)
		
		#moving forward should not change directions
		assert_equal "N", @rover.move('M',@grid)
		assert_equal "E", @rover.move('R',@grid)
		assert_equal "S", @rover.move('R',@grid)
		assert_equal "S", @rover.move('M',@grid)
		assert_equal "E", @rover.move('L',@grid)
		assert_equal "N", @rover.move('L',@grid)
	end

	def test_translation
		@rover.translate(@grid)
		assert_equal 0, @rover.x

		@rover.translate(@grid)
		assert_equal 2, @rover.y

		#off limit transalations
		@rover.translate(Grid.new(2,2))
		assert_equal 2, @rover.y

		@rover.translate(@grid) 
		assert_equal 0, @rover.x

		@rover.move('R',@grid)
		@rover.translate(@grid)
		assert_equal 1, @rover.x
		#rover now faces East
		@rover.translate(@grid)
		assert_equal 2, @rover.x

		@rover.move('R',Grid.new(2,2))
		assert_equal 2, @rover.x
		#rover now faces South
		@rover.translate(@grid)
		assert_equal 2, @rover.y

		@rover.translate(@grid)
		assert_equal 1, @rover.y

		@rover.move('R',@grid)
		#rover now faces West
		@rover.translate(@grid)
		assert_equal 1, @rover.x
	end

	def test_validity
		assert_equal true, @rover.is_valid(4,4,@grid)
		assert_equal false, @rover.is_valid(6,6,@grid)
		assert_equal false, @rover.is_valid(3,6,@grid)
		assert_equal false, @rover.is_valid(6,3,@grid)
	end

end
