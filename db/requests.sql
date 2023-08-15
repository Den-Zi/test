/* Получить минимальную, максимальную и среднюю стоимость всех рабов весом более 60 кг. */
select min(cost), max(cost), avg(cost) from slave where weight > 60;

/* Выбрать категории, в которых больше 10 рабов. */
select sc.id, sc.name from slave_category sc
    inner join slave_category_link scl on sc.id = scl.slave_category_id
    group by sc.id having count(scl.slave_id) > 10;

/* Выбрать категорию с наибольшей суммарной стоимостью рабов.*/
select sc.id, sc.name, sum(sl.cost) sum from slave_category sc
    inner join slave_category_link scl on sc.id = scl.slave_category_id
    inner join slave sl on sl.id = scl.slave_id
    group by sc.id order by sum DESC limit 1;

/* Выбрать категории, в которых мужчин больше чем женщин.*/
select sc.id, sc.name from slave_category sc
    where (select count(*) from slave_category_link scl
        inner join slave sl on scl.slave_id = sl.id and sl.gender = 'male'
        where sc.id = scl.slave_category_id
    ) > (select count(*) from slave_category_link scl
        inner join slave sl on scl.slave_id = sl.id and sl.gender = 'female'
        where sc.id = scl.slave_category_id)
    ;

/* Количество рабов в категории "Для кухни" (включая все вложенные категории). */
select count(*) from slave_category sc
    inner join slave_category_link scl on sc.id = scl.slave_category_id
    left join slave_category sc_target on sc_target.name = 'Для кухни'
    where sc.lft >= sc_target.lft and sc.rgt <= sc_target.rgt
;
