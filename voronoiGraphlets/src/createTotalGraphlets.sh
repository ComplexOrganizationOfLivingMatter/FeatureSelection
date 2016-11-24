#Original
ls | grep dWL | while read f; do echo "$f"; cat "$f" >> dWL_totalGraphlets.ndump2; done;
ls | grep dWP | while read f; do echo "$f"; cat "$f" >> dWP_totalGraphlets.ndump2; done;
ls | grep cNT | while read f; do echo "$f"; cat "$f" >> cNT_totalGraphlets.ndump2; done;
ls | grep omm | while read f; do echo "$f"; cat "$f" >> omm_totalGraphlets.ndump2; done;
ls | grep BC | while read f; do echo "$f"; cat "$f" >> BCA_totalGraphlets.ndump2; done;
ls | grep Diagrama_001.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_001_totalGraphlets.ndump2; done;
ls | grep Diagrama_002.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_002_totalGraphlets.ndump2; done;
ls | grep Diagrama_003.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_003_totalGraphlets.ndump2; done;
ls | grep Diagrama_004.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_004_totalGraphlets.ndump2; done;
ls | grep Diagrama_005.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_005_totalGraphlets.ndump2; done;
ls | grep Diagrama_006.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_006_totalGraphlets.ndump2; done;
ls | grep Diagrama_007.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_007_totalGraphlets.ndump2; done;
ls | grep Diagrama_008.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_008_totalGraphlets.ndump2; done;
ls | grep Diagrama_009.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_009_totalGraphlets.ndump2; done;
ls | grep Diagrama_010.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_010_totalGraphlets.ndump2; done;
ls | grep Diagrama_011.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_011_totalGraphlets.ndump2; done;
ls | grep Diagrama_012.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_012_totalGraphlets.ndump2; done;
ls | grep Diagrama_013.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_013_totalGraphlets.ndump2; done;
ls | grep Diagrama_014.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_014_totalGraphlets.ndump2; done;
ls | grep Diagrama_015.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_015_totalGraphlets.ndump2; done;
ls | grep Diagrama_016.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_016_totalGraphlets.ndump2; done;
ls | grep Diagrama_017.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_017_totalGraphlets.ndump2; done;
ls | grep Diagrama_018.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_018_totalGraphlets.ndump2; done;
ls | grep Diagrama_019.ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_019_totalGraphlets.ndump2; done;

for i in { 20 30 40 50 60 70 80 90 }
do
	ls | grep Diagrama_0"$i".ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_0"$i"_totalGraphlets.ndump2; done;
done

for i in { 100 200 300 400 500 600 700 }
do
	ls | grep Diagrama_"$i".ndump2 | while read f; do echo "$f"; cat "$f" >> imagen_Diagrama_"$i"_totalGraphlets.ndump2; done;
done

#------------------- SickEpithliums --------------#

ls | grep Atrophy- | while read f; do echo "$f"; cat "$f" >> Atrophy_totalGraphlets.ndump2; done;
ls | grep Case-II- | while read f; do echo "$f"; cat "$f" >> Case-II_totalGraphlets.ndump2; done;
ls | grep Case-III- | while read f; do echo "$f"; cat "$f" >> Case-III_totalGraphlets.ndump2; done;
ls | grep Case-IV- | while read f; do echo "$f"; cat "$f" >> Case-IV_totalGraphlets.ndump2; done;
ls | grep Control-Sim-no-Prol- | while read f; do echo "$f"; cat "$f" >> Control-Sim-no-Prol_totalGraphlets.ndump2; done;
ls | grep Control-Sim-Prolif- | while read f; do echo "$f"; cat "$f" >> Control-Sim-Prolif_totalGraphlets.ndump2; done;
ls | grep dMWP | while read f; do echo "$f"; cat "$f" >> dMWP_totalGraphlets.ndump2; done;


#------------------- Cancer ----------------------#
#Columns
# for i in {1..9}
# do
# 	ls | grep _columns_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_0"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _columns_ | grep Diagrama_0"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_0"$i"_weight_2000_totalGraphlets.ndump2; done;
# done

# for i in {10..80}
# do
# 	ls | grep _columns_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _columns_ | grep Diagrama_"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_columns_"$i"_weight_2000_totalGraphlets.ndump2; done;
# done


# #Disk
for i in {1..9}
do
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_2000_OnlyNeighboursOfWeightedCells | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_0"$i"_weight_2000_OnlyNeighboursOfWeightedCells_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_2000_OnlyNeighboursOfWeightedCells | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_"$i"_weight_2000_OnlyNeighboursOfWeightedCells_totalGraphlets.ndump2; done;
done

for i in {1..9}
do
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_2000_OnlyWeightedCells | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_0"$i"_weight_2000_OnlyWeightedCells_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_2000_OnlyWeightedCells | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_"$i"_weight_2000_OnlyWeightedCells_totalGraphlets.ndump2; done;
done

for i in {1..9}
do
	ls | grep _disk_ | grep Diagrama_0"$i"_v3_weight_2000.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_0"$i"_weight_2000_totalGraphlets.ndump2; done;
done

for i in {10..80}
do
	ls | grep _disk_ | grep Diagrama_"$i"_v3_weight_2000.ndump2 | while read f; do echo "$f"; cat "$f" >> voronoiWeighted_disk_"$i"_weight_2000_totalGraphlets.ndump2; done;
done

# #Half
# for i in {1..9}
# do
# 	ls | grep _half_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_0"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _half_ | grep Diagrama_0"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_0"$i"_weight_2000_totalGraphlets.ndump2; done;
# done

# for i in {10..80}
# do
# 	ls | grep _half_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _half_ | grep Diagrama_"$i"_v3_weight_2000 | while read f; do echo "$f"; cat "$f" >> voronoi_half_"$i"_weight_2000_totalGraphlets.ndump2; done;
# done

# #Square
# for i in {1..9}
# do
# 	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_600 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_600_totalGraphlets.ndump2; done;
# 	ls | grep _square_ | grep Diagrama_0"$i"_v3_weight_800 | while read f; do echo "$f"; cat "$f" >> voronoi_square_0"$i"_weight_800_totalGraphlets.ndump2; done;
# done

# for i in {10..20}
# do
# 	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_1000 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_1000_totalGraphlets.ndump2; done;
# 	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_600 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_600_totalGraphlets.ndump2; done;
# 	ls | grep _square_ | grep Diagrama_"$i"_v3_weight_800 | while read f; do echo "$f"; cat "$f" >> voronoi_square_"$i"_weight_800_totalGraphlets.ndump2; done;
# done

#------------------- voronoi noise -------------------#

for i in {1..9}
do
	ls | grep Voronoi_00"$i"_ | while read f; do echo "$f"; cat "$f" >> voronoiNoise_00"$i"_totalGraphlets.ndump2; done;
done

for i in {10..20} 
do
	ls | grep Voronoi_0"$i"_ | while read f; do echo "$f"; cat "$f" >> voronoiNoise_0"$i"_totalGraphlets.ndump2; done;
done

for i in { 30 40 50 60 70 80 90 } 
do
	ls | grep Voronoi_0"$i"_ | while read f; do echo "$f"; cat "$f" >> voronoiNoise_0"$i"_totalGraphlets.ndump2; done;
done



for i in { 100 200 300 400 500 600 700 } 
do
	ls | grep Voronoi_"$i"_ | while read f; do echo "$f"; cat "$f" >> voronoiNoise_"$i"_totalGraphlets.ndump2; done;
done