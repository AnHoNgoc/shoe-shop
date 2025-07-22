USE shoe_shop;

INSERT INTO Category (name, image, created_at, updated_at)
VALUES
  ('All', "https://icons.veryicon.com/png/o/miscellaneous/smarteditor/select-all-style-instances.png", NOW(), NOW()),
  ('Nike', "https://pngfre.com/wp-content/uploads/nike-logo-18-1024x1024.png", NOW(), NOW()),
  ('Adidas', "https://upload.wikimedia.org/wikipedia/commons/2/24/Adidas_logo.png", NOW(), NOW()),
  ('Puma', "https://cdn.freebiesupply.com/logos/large/2x/puma-3-logo-black-and-white.png", NOW(), NOW()),
  ('Converse', "https://www.zumiez.com/media/wysiwyg/converse_3_.png", NOW(), NOW()),
  ('Vans', 'https://cdn.inspireuplift.com/uploads/images/seller_products/1677833123_a1-01.png', NOW(), NOW());
  
INSERT INTO `Group` (name, description) VALUES 
('admin', 'Development team'),
('employee', 'General employees'),
('customer', 'Customers of the company');

INSERT INTO Role (url, description) VALUES 
('/user/list', 'Access to view the list of users'),
('/user/create', 'Access to create new users'),
('/user/update', 'Access to update existing users'),
('/user/delete', 'Access to delete users'),
('/role/list', 'Access to view the list of roles'),
('/role/create', 'Access to create new roles'),
('/role/delete', 'Access to delete roles'),
('/role/by-group', 'Access to view roles by group'),
('/role/assign-to-group', 'Access to assign roles to groups'),
('/group/list', 'Access to view the list of groups');



INSERT INTO Product (name, price, quantity, image, category_id, created_at, updated_at)
VALUES
-- Nike (categoryId = 1)
('Nike Air Max 1', 120.99, 50, 'https://cdn.storims.com/api/v2/image/resize?path=https://storage.googleapis.com/storims_cdn/storims/uploads/c8b6daa2d81f1b10688177d4d9729bb5.jpeg&format=jpeg', 2, NOW(), NOW()),
('Nike Air Force 1', 110.00, 40, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/3f3e7049-5c99-428c-abcd-e246b086f2ed/AIR+FORCE+1+%2707.png', 2, NOW(), NOW()),
('Nike ZoomX', 150.49, 30, 'https://runningstore.vn/wp-content/uploads/2024/09/z5836503815290_745db30531cb9e18e264d2a57807042f.jpg', 2, NOW(), NOW()),
('Nike Pegasus', 99.99, 20, 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/aefedd69-868a-4bd2-a484-b383dcae7a67/custom-nike-air-zoom-pegasus-41-shoes-by-you.png', 2, NOW(), NOW()),
('Nike React', 89.95, 25, 'https://teemosneaker.com/wp-content/uploads/2024/12/z6030885038832_fd48ce664c4f798d08fbef3079d96ca2-1.jpg', 2, NOW(), NOW()),

-- Adidas (categoryId = 3)
('Adidas Ultraboost', 130.00, 35, 'https://runningstore.vn/wp-content/uploads/2022/03/4ac2c26e84ad4bf312bc.jpg', 3, NOW(), NOW()),
('Adidas NMD', 125.50, 28, 'https://sneakerdaily.vn/wp-content/uploads/2024/04/Giay-Adidas-NMD-R1-Glitch-Black-White-FV3649-1.jpg', 3, NOW(), NOW()),
('Adidas Gazelle', 95.99, 60, 'https://sneakerdaily.vn/wp-content/uploads/2024/04/Giay-adidas-Gazelle-Indoor-Gatsin-Pack-White-Black-IH9990.jpg', 3, NOW(), NOW()),
('Adidas Forum Low', 110.20, 22, 'https://sneakerdaily.vn/wp-content/uploads/2024/10/Giay-Adidas-Forum-Low-CL-%E2%80%98Beige-IH7826.jpg', 3, NOW(), NOW()),
('Adidas Samba', 80.00, 45, 'https://sneakerdaily.vn/wp-content/uploads/2024/08/Giay-Adidas-Samba-OG-%E2%80%98Wonder-White-Maroon-IG1987.jpg', 3, NOW(), NOW()),

-- Puma (categoryId = 4)
('Puma RS-X', 105.00, 32, 'https://sneakerholicvietnam.vn/wp-content/uploads/2020/08/32fbbac766d389fdb52790df259029ce-1.jpeg', 4, NOW(), NOW()),
('Puma Suede Classic', 75.00, 48, 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/399781/10/sv01/fnd/PNA/fmt/png/Suede-Classic-Sneakers', 4, NOW(), NOW()),
('Puma Future Rider', 85.99, 50, 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/391926/06/sv01/fnd/PHL/fmt/png/Future-Rider-Concrete-Jungle-Sneakers', 4, NOW(), NOW()),
('Puma Cali Sport', 95.00, 38, 'https://m.media-amazon.com/images/I/81PbjAplQoL._AC_UY1000_.jpg', 4, NOW(), NOW()),
('Puma Slipstream', 110.49, 26, 'https://fado.vn/blog/wp-content/uploads/2023/02/Puma-Slipstream-White-Intense-Red.jpg', 4, NOW(), NOW()),

-- Converse (categoryId = 5)
('Converse Chuck Taylor', 60.00, 80, 'https://sneakerholicvietnam.vn/wp-content/uploads/2020/07/converse-chuck-taylor-all-star-move-black-568497c-2.jpg', 5, NOW(), NOW()),
('Converse Run Star Hike', 90.00, 33, 'https://cdn.storims.com/api/v2/image/resize?path=https://storage.googleapis.com/storims_cdn/storims/uploads/b0a91c93bf20a61a5315c51b40643598.jpeg&format=jpeg', 5, NOW(), NOW()),
('Converse All Star Pro', 85.00, 44, 'https://d3pnpe87i1fkwu.cloudfront.net/IMG/converse-all-star-pro-bb-166322c_1170x1170.png', 5, NOW(), NOW()),
('Converse One Star', 70.00, 36, 'https://images-na.ssl-images-amazon.com/images/I/51+sQItnQvL.jpg', 5, NOW(), NOW()),
('Converse Weapon CX', 100.00, 20, 'https://i.ebayimg.com/images/g/9cwAAOSwzPpkwBIi/s-l1200.jpg', 5, NOW(), NOW()),

-- Vans (categoryId = 6)
('Vans Old Skool', 65.00, 70, 'https://bizweb.dktcdn.net/100/494/688/products/c7e7e2e3-09a9-414a-acaa-8196f246bd62-jpeg-1688640127885.jpg?v=1722329296697', 6, NOW(), NOW()),
('Vans Sk8-Hi', 75.00, 55, 'https://bizweb.dktcdn.net/100/140/774/products/vans-x-national-geographic-sk8-hi-reissue-138-vn0a3tkpxhp-2.jpg?v=1600874203747', 6, NOW(), NOW()),
('Vans Authentic', 60.00, 50, 'https://bizweb.dktcdn.net/100/140/774/products/vans-classic-authentic-red-vn000ee3red-2.png?v=1625932680123', 6, NOW(), NOW()),
('Vans Era', 55.00, 60, 'https://bizweb.dktcdn.net/100/140/774/products/vans-era-classic-white-vn0a4u39frl-2.jpg?v=1578484171907', 6, NOW(), NOW()),
('Vans UltraRange', 80.00, 40, 'https://media.lotsthailand.com/media/catalog/product/cache/1385b635fbcd2b4a1bd7d222a65ada37/v/n/vn000cwcbgi_hero_1_wnrrckw5xiwdikiu.jpg', 6, NOW(), NOW());
