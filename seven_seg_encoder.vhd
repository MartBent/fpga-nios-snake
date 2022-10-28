library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_encoder is
  port(
	 score : in std_logic_vector(5 downto 0);
	 output : out std_logic_vector(13 downto 0)
	 );
end seven_seg_encoder;

architecture behavior of seven_seg_encoder is
begin
	process(score)
	begin
		case score is
			when "000000" =>
				output <= "11111101111110";
			when "000001" =>
				output <= "11111100110000";
			when "000010" =>
				output <= "11111101101101";
			when "000011" =>
				output <= "11111101111001";
			when "000100" =>
				output <= "11111100110011";
			when "000101" =>
				output <= "11111101011011";
			when "000110" =>
				output <= "11111101011111";
			when "000111" =>
				output <= "11111101110000";
			when "001000" =>
				output <= "11111101111111";
			when "001001" =>
				output <= "11111101111011";
			when "001010" =>
				output <= "01100001111110"; --10
			when "001011" =>
				output <= "01100000110000"; --11
			when "001100" =>
				output <= "01100001101101"; --12
			when "001101" =>
				output <= "01100001111001"; --13
			when "001110" =>
				output <= "01100000110011"; --14
			when "001111" =>
				output <= "01100001011011"; --15
			when "010000" =>
				output <= "01100001011111"; --16
			when "010001" =>
				output <= "01100001110000"; --17
			when "010010" =>
				output <= "01100001111111"; --18
			when "010011" =>
				output <= "01100001111011"; --19
			when "010100" =>
				output <= "11011011111110"; --20
			when "010101" =>
				output <= "11011010110000"; --21
			when "010110" =>
				output <= "11011011101101"; --22
			when "010111" =>
				output <= "11011011111001"; --23
			when "011000" =>
				output <= "11011010110011"; --24
			when "011001" =>
				output <= "11011011011011"; --25
			when "011010" =>
				output <= "11011011011111"; --26
			when "011011" =>
				output <= "11011011110000"; --27
			when "011100" =>
				output <= "11011011110000"; --28
			when "011101" =>
				output <= "11011011111011"; --29
			when "011110" =>
				output <= "11110011111110"; --30
			when "011111" =>
				output <= "11110010110000"; --31
			when "100000" =>
				output <= "11110011101101"; --32
			when "100001" =>
				output <= "11110011111001"; --33
			when others =>
				output <= "11111111111111";
			end case;
		end process;
	end behavior;