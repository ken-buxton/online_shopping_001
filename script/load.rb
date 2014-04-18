# *********************************************************************
# Table Load
# FoodFeature
# State
# Store
# Customer
# Product
# *********************************************************************
module ActiveRecord
  class Base
    def self.reset_pk_sequence
      case ActiveRecord::Base.connection.adapter_name
      when 'SQLite'
        new_max = maximum(primary_key) || 0
        update_seq_sql = "update sqlite_sequence set seq = #{new_max} where name = '#{table_name}';"
        ActiveRecord::Base.connection.execute(update_seq_sql)
      when 'PostgreSQL'
        ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
      else
        raise "Task not implemented for this DB adapter"
      end
    end     
  end
end

# Add required food features
FoodFeature.delete_all
FoodFeature.reset_pk_sequence
FoodFeature.create(name: 'Organic', descr: 'Organic')
FoodFeature.create(name: 'Gluten Free', descr: 'Gluten Free')
FoodFeature.create(name: 'Buy Michigan', descr: 'Buy Michigan')
FoodFeature.create(name: 'Non-GMO', descr: 'Non-GMO')
FoodFeature.create(name: 'Lactose Free', descr: 'Lactose Free')
FoodFeature.create(name: 'High Fiber', descr: 'High Fiber')
FoodFeature.create(name: 'Whole Grain', descr: 'Whole Grain')
FoodFeature.create(name: 'Sugar Free', descr: 'Sugar Free')
FoodFeature.create(name: 'Kosher', descr: 'Kosher')
FoodFeature.create(name: 'Halal', descr: 'Halal')
FoodFeature.create(name: 'Antibiotic Free', descr: 'Antibiotic Free')

State.delete_all
State.reset_pk_sequence
State.create(state: 'Michigan', state2: 'MI')
State.create(state: 'Ohio', state2: 'OH')
state_id_mi = State.find_by_state2('MI').id

Store.delete_all
Store.reset_pk_sequence
Store.create(name: 'Blissfield', address1: '628 W Adrian St', address2: '', city: 'Blissfield', state_id: state_id_mi, zip: '49228')
Store.create(name: 'Napoleon', address1: '7880 Napoleon Road', address2: '', city: 'Napoleon Township', state_id:  state_id_mi, zip: '49261')
Store.create(name: 'Morenci', address1: '248 West Main Street', address2: '', city: 'Morenci', state_id:  state_id_mi, zip: '49256')

# *********************************************************************
# Products
# *********************************************************************
$load_no = 1
def prod_create(sku, upc, brand, descr, qty_desc, min_qty_weight, image, 
    category, sub_category, sub_category_group, food_feature, uofm, price, sale_price, on_sale, featured_item)
  Product.create(sku: sku, upc: upc, brand: brand, descr: descr,  #descr: descr + "(#{$load_no})", 
    qty_desc: qty_desc, min_qty_weight: min_qty_weight, image: image, 
    category: category, sub_category: sub_category, sub_category_group: sub_category_group, sub_category_group: sub_category_group, food_feature: food_feature, 
    uofm: uofm, price: price, sale_price: sale_price, on_sale: on_sale, featured_item: featured_item)  
    $load_no += 1
end

Product.delete_all
Product.reset_pk_sequence
# ***********************************************************
# Category: Meat
# ***********************************************************
#           sku,           upc,           brand,                  descr,                                 qty_desc,   min_qty_weight, image,             category,    sub_category, sub_category_group, food_feature,    uofm,     price,   sale_price, on_sale   featured_item
# ***** Sub-category: Beef ************************
prod_create('10000010101', '10000010101', '',                     'Beef & Pork - Meatloaf Mix',          'per lb',   1.6,            'meat/MeBf01.jpg', 'Meat',     'Beef',        'Cheap',            '',              'lb',      3.99,    3.99,      false,    true)
prod_create('10000010102', '10000010102', 'Busch\'s',             'Ground Beef - Chuck',                 'per lb',   1.2,            'meat/MeBf02.jpg', 'Meat',     'Beef',        'Cheap',            '',              'lb',      3.59,    3.29,      true,     false)
prod_create('10000010103', '10000010103', '',                     'Premium Usda Choice - Filet Mignon',  'per lb',   0.8,            'meat/MeBf03.jpg', 'Meat',     'Beef',        'Premium',          'Buy Michigan',  'lb',     24.99,   24.49,      false,    false)
# ***** Sub-category: Breakfast *******************
prod_create('10000010201', '10000010201', 'Alexander & Hornung',  'Bacon - Pepper',                      '24 oz',    0.0,            'meat/MeBr01.jpg', 'Meat',     'Breakfast',   '',                 'Buy Michigan',  'each',   11.99,   11.99,      false,    false)
prod_create('10000010202', '10000010202', 'Bob Evans',            'Pork Sausage - Maple Patties',        '12 oz',    0.0,            'meat/MeBr02.jpg', 'Meat',     'Breakfast',   '',                 '',              'each',    4.49,    4.29,      true,     false)
prod_create('10000010203', '10000010203', 'Dearborn',             'Canadian Style Bacon - Chub',         'per lb',   1.0,            'meat/MeBr03.jpg', 'Meat',     'Breakfast',   '',                 '',              'lb',      6.49,    6.49,      false,    true)
# ***** Sub-category: Poultry *********************
prod_create('10000010301', '10000010301', 'Farm Fresh',           'Chicken - Boneless Skinless Breast',  'per lb',   1.5,            'meat/MePo01.jpg', 'Meat',     'Poultry',     'Regular',          'Buy Michigan',  'lb',      2.99,    2.99,      true,     false)
prod_create('10000010302', '10000010302', 'Jennie-o',             'Breakfast Sausages - Turkey Links',   '12 oz',    0.0,            'meat/MePo02.jpg', 'Meat',     'Poultry',     'Ground',           '',              'each',    3.99,    3.99,      false,    false)
prod_create('10000010303', '10000010303', 'Jennie-o',             'Marinated Tenderloin - Chipotle Bbq', '24 oz',    0.0,            'meat/MePo03.jpg', 'Meat',     'Poultry',     'Regular',          '',              'each',    8.99,    8.99,      false,    true)
  
# ***********************************************************
# Category: Produce
# ***********************************************************
# ***** Sub-category: Bulk Foods ******************
prod_create('10000020101', '10000020101', '',                     'Almonds - Chocolate',                 'per lb',   0.5,            'prod/PrBf01.jpg', 'Produce',  'Bulk Foods',  'Chocolate',        'Gluten Free',   'lb',      7.49,    7.49,      false,    true)
prod_create('10000020102', '10000020102', '',                     'Bridge Mix - Chocolate',              'per lb',   0.7,            'prod/PrBf02.jpg', 'Produce',  'Bulk Foods',  'Chocolate',        'Gluten Free',   'lb',      5.99,    5.99,      false,    true)
prod_create('10000020103', '10000020103', '',                     'Bulk Mix - Country',                  'per lb',   1.2,            'prod/PrBf03.jpg', 'Produce',  'Bulk Foods',  'Country',          'Gluten Free',   'lb',      3.49,    3.49,      false,    false)
# ***** Sub-category: Fruit ***********************
prod_create('10000020201', '10000020201', '',                     'Apples - Fuji',                       'per lb',   0.5,            'prod/PrFr01.jpg', 'Produce',  'Fruit',       'Apples',           '',              'lb',      1.99,    1.99,      false,    false)
prod_create('10000020202', '10000020202', 'Dole',                 'Bananas',                             'per lb',   0.4,            'prod/PrFr02.jpg', 'Produce',  'Fruit',       'Bananas',          '',              'lb',      0.59,    0.59,      false,    true)
prod_create('10000020203', '10000020203', '',                     'Mangos',                              '1 ea',     0.0,            'prod/PrFr03.jpg', 'Produce',  'Fruit',       '',                 '',              'each',    1.00,    1.00,      true,     false)
# ***** Sub-category: Vegetables ******************
prod_create('10000020301', '10000020301', '',                     'Beans - Green',                       'per lb',   0.0,            'prod/PrVe01.jpg', 'Produce',  'Vegetables',  'Raw',              'High Fiber',    'lb',      1.29,    1.29,      true,     false)
prod_create('10000020302', '10000020302', 'Busch\'s',             'Fresh Salsa',                         '12 oz',    0.0,            'prod/PrVe02.jpg', 'Produce',  'Vegetables',  'Made',             'High Fiber',    'each',    2.99,    2.99,      true,     true)
prod_create('10000020303', '10000020303', 'Earthbound',           'Farm Salad - Half & Half',            '5 oz',     0.0,            'prod/PrVe03.jpg', 'Produce',  'Vegetables',  'Raw',              'High Fiber',    'each',    3.99,    3.99,      false,    false)

# ***********************************************************
# Category: Dairy
# ***********************************************************
# ***** Sub-category: Cheese *********************
prod_create('10000030101', '10000030101', 'Dairy Fresh ',         'Individual Wrap Cheese - American 8 Oz','8 oz',   0.0,            'dair/DrCh01.jpg', 'Dairy',    'Cheese',      'Cheap',            'Gluten Free',   'each',    2.19,    2.19,      false,    true)
prod_create('10000030102', '10000030102', 'Kraft',                'Chunk Cheese - Colby',                '8 oz',     0.0,            'dair/DrCh02.jpg', 'Dairy',    'Cheese',      'Medium Price',     '',              'each',    4.79,    4.79,      false,    false)
prod_create('10000030103', '10000030103', 'Kraft',                'Shredded Cheese - Cheddar Fat Free',  '7 oz',     0.0,            'dair/DrCh03.jpg', 'Dairy',    'Cheese',      'Medium Price',     '',              'each',    3.49,    3.49,      false,    false)
# ***** Sub-category: Eggs *********************
prod_create('10000030201', '10000030201', 'Egg Beaters',          'Original',                            '16 oz',    0.0,            'dair/DrEg01.jpg', 'Dairy',    'Eggs',        'Small',            '',              'each',    3.29,    3.29,      false,    true)
prod_create('10000030202', '10000030202', 'Egglands Best',        'Eggs - Cage Free Grade A Brown',      '12 cnt',   0.0,            'dair/DrEg02.jpg', 'Dairy',    'Eggs',        'Small',            '',              'each',    3.99,    3.99,      false,    false)
prod_create('10000030203', '10000030203', 'Organic Valley',       'Eggs - Extra Large',                  '6 cnt',    0.0,            'dair/DrEg03.jpg', 'Dairy',    'Eggs',        'Large',            '',              'each',    3.69,    3.69,      false,    false)
# ***** Sub-category: Milk *********************
prod_create('10000030301', '10000030301', 'Almond Breeze',        'Milk - Original',                     '64 oz',    0.0,            'dair/DrMi01.jpg', 'Dairy',    'Milk',        'Milk',             'Lactose Free',  'each',    3.99,    3.99,      false,    true)
prod_create('10000030302', '10000030302', 'Coffee Mate',          'Half & Half - Hazelnut',              '32 oz',    0.0,            'dair/DrMi02.jpg', 'Dairy',    'Milk',        'Cream',            '',              'each',    4.49,    4.49,      false,    true)
prod_create('10000030303', '10000030303', 'Dairy Fresh',          'Whipped Cream - Light',               '7 oz',     0.0,            'dair/DrMi03.jpg', 'Dairy',    'Milk',        'Cream',            'Lactose Free',  'each',    2.85,    2.85,      false,    false)

# *********************************************************************
# Customers
# *********************************************************************
preferred_store_id_bl = Store.find_by_name('Blissfield').id
preferred_store_id_na = Store.find_by_name('Napoleon').id
preferred_store_id_mo = Store.find_by_name('Morenci').id
Customer.delete_all
Customer.reset_pk_sequence
Customer.create(email: "ken@gmail.com", password_digest: "12345", account_no: "12345678", preferred_store_id: preferred_store_id_bl, 
  first_name: "Ken", last_name: "Buxton", nick_name: "Ken", home_phone: "", cell_phone: "517-902-1572", 
  address1: "513 E. Logan", address2: "", city: "Tecumseh", state_id: state_id_mi, zip: "49286")
Customer.create(email: "betty@hotmail.com", password_digest: "12345", account_no: "32453789", preferred_store_id: preferred_store_id_na, 
  first_name: "Elizabeth", last_name: "Smith", nick_name: "Betty", home_phone: "888-919-5555", cell_phone: "", 
  address1: "27 Main", address2: "", city: "Brooklyn", state_id: state_id_mi, zip: "49230")
Customer.create(email: "john.doe@gmail.com", password_digest: "12345", account_no: "93701635", preferred_store_id: preferred_store_id_mo, 
  first_name: "Johnathon", last_name: "Doe", nick_name: "John", home_phone: "234-583-5555", cell_phone: "", 
  address1: "143 Oak", address2: "", city: "Morenci", state_id: state_id_mi, zip: "49256")

# *********************************************************************
# Customer Shopping Lists
# *********************************************************************
CustomerShoppingList.delete_all
CustomerShoppingList.reset_pk_sequence
customer_id_kb = Customer.find_by_email("ken@gmail.com").id
customer_id_be = Customer.find_by_email("betty@hotmail.com").id
CustomerShoppingList.create(customer_id: customer_id_kb, shopping_list_name: "Weekday")
CustomerShoppingList.create(customer_id: customer_id_kb, shopping_list_name: "Weekend")
CustomerShoppingList.create(customer_id: customer_id_kb, shopping_list_name: "Holiday")
CustomerShoppingList.create(customer_id: customer_id_be, shopping_list_name: "Only")
  
# *********************************************************************
# Customer Shopping List Items
# *********************************************************************
CustomerShoppingListItem.delete_all
CustomerShoppingListItem.reset_pk_sequence

product_id_whip_cream = Product.find_by_sku("10000030303").id
product_id_bananas = Product.find_by_sku("10000020202").id
product_id_filet = Product.find_by_sku("10000010103").id
product_id_milk = Product.find_by_sku("10000030301").id
product_id_salsa = Product.find_by_sku("10000020302").id

customer_shopping_list_id_kb_wd = CustomerShoppingList.find_by_customer_id_and_shopping_list_name(customer_id_kb, "Weekday").id
customer_shopping_list_id_kb_we = CustomerShoppingList.find_by_customer_id_and_shopping_list_name(customer_id_kb, "Weekend").id
customer_shopping_list_id_kb_ho = CustomerShoppingList.find_by_customer_id_and_shopping_list_name(customer_id_kb, "Holiday").id
customer_shopping_list_id_bo_on = CustomerShoppingList.find_by_customer_id_and_shopping_list_name(customer_id_be, "Only").id

CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_wd, product_id: product_id_whip_cream, quantity: 1.0, note: "A note 1")  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_wd, product_id: product_id_bananas, quantity: 3.0, note: "A note 2")
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_wd, product_id: product_id_filet, quantity: 2.0, note: "A note 2")
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_wd, product_id: product_id_milk, quantity: 1.0, note: "A note 2")
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_wd, product_id: product_id_salsa, quantity: 1.0, note: "A note 2")
  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_we, product_id: product_id_whip_cream, quantity: 1.0, note: "A note 3")  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_we, product_id: product_id_bananas, quantity: 1.0, note: "A note 4")
  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_ho, product_id: product_id_filet, quantity: 2.0, note: "A note 5")  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_kb_ho, product_id: product_id_milk, quantity: 1.0, note: "A note 6")
  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_bo_on, product_id: product_id_filet, quantity: 2.0, note: "A note 5")  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_bo_on, product_id: product_id_milk, quantity: 2.0, note: "A note 6")  
CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list_id_bo_on, product_id: product_id_salsa, quantity: 1.0, note: "A note 7")  
  
# *********************************************************************
# Customer Items
# *********************************************************************
CustomerItem.create(customer_id: customer_id_kb, product_id: product_id_whip_cream)
CustomerItem.create(customer_id: customer_id_kb, product_id: product_id_bananas)
CustomerItem.create(customer_id: customer_id_kb, product_id: product_id_filet)
CustomerItem.create(customer_id: customer_id_kb, product_id: product_id_milk)
CustomerItem.create(customer_id: customer_id_kb, product_id: product_id_salsa)




