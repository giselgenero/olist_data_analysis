SELECT order_id, c.first_name, c.last_name, c.email FROM olist.orders o 
join olist.customers c
on o.customer_id = c.customer_id;


 select order_id, count(product_id) as cant
 from olist.order_items
 group by order_id
 order by cant desc;
 
 -- Calcular la cantidad de cada producto por pedido y el subtotal por línea
SELECT 
    order_id,
    product_id,
    COUNT(product_id) AS quantity,
    price,
    COUNT(product_id) * price AS line_total
FROM 
    olist.order_items
    where order_id = '8272b63d03f5f79c56e9e4120aec44ef'
GROUP BY 
    order_id, product_id, price;
    
    -- Calcular el total de la venta por pedido
SELECT 
	order_id,
    SUM(line_total) AS total_sale
FROM (
				SELECT 
					order_id,
					product_id,
					price,
					COUNT(product_id) AS quantity,
					COUNT(product_id) * price AS line_total
				FROM 
					olist.order_items
				WHERE 
					order_id = '8272b63d03f5f79c56e9e4120aec44ef'
				GROUP BY 
					order_id, product_id, price
			) AS subquery  
GROUP BY 
    order_id;
    
    select monthname(order_purchase_timestamp) as mes, count(order_id) as cant from orders
    group by mes
    order by mes;

 -- utilizar la función SUM() junto con GROUP BY para agregar las ventas por mes . Por ejemplo: SELECT MONTH(sale_date), SUM(sales_amount) FROM sales GROUP BY MONTH(sale_date);