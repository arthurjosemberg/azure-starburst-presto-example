SELECT 
    soh.salesorderid AS idVenda,
    COUNT(p.productid) AS qtdProdutosVendidos
FROM sqldatabase_advworks.saleslt.salesorderheader AS soh
JOIN hive.adventureworks.salesorderdetail AS sod ON soh.salesorderid = sod.salesorderid
JOIN mongodb_advworks.adventureworks.product AS p ON p.productid = sod.productid
GROUP BY soh.salesorderid
ORDER BY qtdProdutosVendidos DESC