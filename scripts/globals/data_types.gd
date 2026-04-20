class_name DataTypes

#创建人物状态的枚举（enum）
enum Tools {
	None,
	AxeWood,
	TillGround,
	WaterCrops,
	PlantCron,
	PlantTomato
}

enum GrowthStates {
	Seed,
	#发芽
	Germination,
	#营养生长
	Vegetative,
	#繁殖生长
	Reproduction,
	#成熟
	Maturity,
	#收获
	Harvesting
}
