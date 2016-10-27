#Original
# ls | grep dWL | while read f; do echo "$f"; cat "$f" >> dWL_totalGraphlets.ndump2; done;
# ls | grep dWP | while read f; do echo "$f"; cat "$f" >> dWP_totalGraphlets.ndump2; done;
# ls | grep cNT | while read f; do echo "$f"; cat "$f" >> cNT_totalGraphlets.ndump2; done;
# ls | grep omm | while read f; do echo "$f"; cat "$f" >> eye_totalGraphlets.ndump2; done;
# ls | grep Diagrama_20_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_20_totalGraphlets.ndump2; done;
# ls | grep BC | while read f; do echo "$f"; cat "$f" >> BCA_totalGraphlets.ndump2; done;
# ls | grep Diagrama_01_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_01_totalGraphlets.ndump2; done;
# ls | grep Diagrama_02_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_02_totalGraphlets.ndump2; done;
# ls | grep Diagrama_03_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_03_totalGraphlets.ndump2; done;
# ls | grep Diagrama_04_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_04_totalGraphlets.ndump2; done;
# ls | grep Diagrama_05_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_05_totalGraphlets.ndump2; done;
# ls | grep Diagrama_06_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_06_totalGraphlets.ndump2; done;
# ls | grep Diagrama_07_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_07_totalGraphlets.ndump2; done;
# ls | grep Diagrama_08_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_08_totalGraphlets.ndump2; done;
# ls | grep Diagrama_09_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_09_totalGraphlets.ndump2; done;
# ls | grep Diagrama_10_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_10_totalGraphlets.ndump2; done;
# ls | grep Diagrama_11_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_11_totalGraphlets.ndump2; done;
# ls | grep Diagrama_12_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_12_totalGraphlets.ndump2; done;
# ls | grep Diagrama_13_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_13_totalGraphlets.ndump2; done;
# ls | grep Diagrama_14_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_14_totalGraphlets.ndump2; done;
# ls | grep Diagrama_15_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_15_totalGraphlets.ndump2; done;
# ls | grep Diagrama_16_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_16_totalGraphlets.ndump2; done;
# ls | grep Diagrama_17_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_17_totalGraphlets.ndump2; done;
# ls | grep Diagrama_18_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_18_totalGraphlets.ndump2; done;
# ls | grep Diagrama_19_data.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoi_19_totalGraphlets.ndump2; done;
#------------------- Cancer ----------------------#
#Columns
for i in {1..9}
do
	ls | grep _columns_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_0"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _columns_ | grep Diagrama_0"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_0"$i"_weight_2000_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _columns_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _columns_ | grep Diagrama_"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_"$i"_weight_2000_totalGraphlets.ndump2; done;
done


#Disk
for i in {1..9}
do
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_500_1000_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_0"$i"_weight_500_1000_2000_totalGraphlets.ndump2; done;
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_0"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_0"$i"_weight_2000_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_500_1000_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_"$i"_weight_500_1000_2000_totalGraphlets.ndump2; done;
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_disk_"$i"_weight_2000_totalGraphlets.ndump2; done;
done

#Half
for i in {1..9}
do
	ls | grep _half_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_0"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _half_ | grep Diagrama_0"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_0"$i"_weight_2000_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _half_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _half_ | grep Diagrama_"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_"$i"_weight_2000_totalGraphlets.ndump2; done;
done

#Square
for i in {1..9}
do
	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_600 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_600_totalGraphlets.ndump2; done;
	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_800 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_800_totalGraphlets.ndump2; done;
done

for i in {10..20}
do
	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_1000_totalGraphlets.ndump2; done;
	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_600 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_600_totalGraphlets.ndump2; done;
	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_800 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_800_totalGraphlets.ndump2; done;
done