import '../components/getdata_components.dart';

class Data{
  var adminData;
  var categoryData;
  var furnitureData;

  Data(this.adminData,this.categoryData,this.furnitureData);

  setAdminData()async{
     adminData = await getData("Admin");
     //return adminData;
  }
  setCategoryData()async{
    categoryData = await getData("Category");
    //return categoryData;
  }
  setFurntiureData()async{
    furnitureData = await getDataFurniture("Furniture","Category");
    //return furnitureData;
  }
}