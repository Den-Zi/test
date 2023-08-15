/* Данные для тестирования запросов*/

insert into place_capture(name) values
    ('Африка'), 
    ('Азия'),
    ('Центральная Африка')  
    ;

/* Генерация nested sets */
insert into slave_category(name, lft, rgt) values
    ('root', 2, 3),              
    ('Популярное', 5, 7),        
    ('Для кухни', 1, 5),         
    ('Мытьё посуды', 7, 4)       
    ;

insert into slave(name, gender, age, weight, skin_color,
    place_capture_id, price_per_hour, cost) values
    ('Джородж', 'male', 35, 72, 'white', 1, 300, 800),    
    ('Альпачино', 'male', 44, 51, 'white', 1, 300, 700),   
    ('Боб', 'male', 43, 60, 'white', 1, 300, 500),   
    ('Джоа', 'female', 40, 10, 'white', 1, 300, 800) 
    ;

insert into slave_category_link(slave_id, slave_category_id) values
    (1, 3),
    (2, 3),
    (3, 2),

    (4, 3),
    (4, 4)
    ;
