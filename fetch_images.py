import urllib.request
import time

base_url = 'https://loremflickr.com/400/500/'
queries = [
    # WOMEN
    ('women,gown', 'Elegant Evening Gown'),
    ('women,dress', 'Casual Spring Dress'),
    ('women,blazer', 'Office Blazer'),
    ('women,skirt', 'Summer Floral Skirt'),
    ('women,sweater', 'Cozy Winter Sweater'),
    # MEN
    ('men,suit', 'Classic Formal Suit'),
    ('men,shirt', 'Casual Denim Shirt'),
    ('men,jacket', 'Leather Jacket'),
    ('men,shorts', 'Summer Shorts'),
    ('men,polo', 'Cotton Polo Shirt'),
    # KIDS
    ('toddler,onesie', 'Cute Dinosaur Onesie'),
    ('kids,overalls', 'Kids Denim Overalls'),
    ('girl,dressparty', 'Princess Party Dress'),
    ('boys,wintercoat', 'Boys Winter Coat'),
    ('kids,rainboots', 'Colorful Rain Boots'),
    # SHOES
    ('shoes,sneakers', 'Pro Running Sneakers'),
    ('shoes,trainers', 'Classic Canvas Trainers'),
    ('shoes,oxford', 'Leather Oxford Shoes'),
    ('shoes,sandals', 'Summer Beach Sandals'),
    ('shoes,hikingboots', 'Winter Hiking Boots'),
    # BEAUTY
    ('makeup,lipstick', 'Luxury Lipstick Set'),
    ('skincare,serum', 'Organic Face Serum'),
    ('perfume,bottle', 'Designer Perfume'),
    ('makeup,eyeshadow', 'Eyeshadow Palette'),
    ('makeup,brushes', 'Complete Brush Set'),
    # GLASSES
    ('sunglasses,aviator', 'Aviator Sunglasses'),
    ('glasses,retro', 'Retro Round Frames'),
    ('sunglasses,polarized', 'Sport Polarized Glasses'),
    ('sunglasses,cateye', 'Oversized Cat-Eye'),
    ('glasses,computer', 'Blue Light Blockers'),
    # BAGS
    ('bag,tote', 'Premium Leather Tote'),
    ('backpack,canvas', 'Canvas Backpack'),
    ('bag,clutch', 'Evening Party Clutch'),
    ('bag,messenger', 'Crossbody Messenger'),
    ('wallet,leather', 'Minimalist Wallet'),
    # JACKETS
    ('jacket,denim', 'Classic Denim Jacket'),
    ('jacket,puffer', 'Winter Puffer Jacket'),
    ('jacket,leather', 'Leather Biker Jacket'),
    ('jacket,windbreaker', 'Light Windbreaker'),
    ('coat,trench', 'Wool Trench Coat'),
    # ACCESSORIES
    ('jewelry,necklace', 'Gold Necklace'),
    ('watch,wrist', 'Classic Wristwatch'),
    ('jewelry,earrings', 'Pearl Earrings'),
    ('scarf,silk', 'Silk Scarf'),
    ('belt,leather', 'Leather Belt'),
    # HOME
    ('furniture,sofa', 'Modern Living Sofa'),
    ('mug,coffee', 'Ceramic Coffee Mug'),
    ('blanket,throw', 'Cozy Throw Blanket'),
    ('plant,indoor', 'Indoor Plant Pot'),
    ('clock,wall', 'Minimalist Wall Clock'),
]

final_lines = []
for i, (query, title) in enumerate(queries):
    try:
        req = urllib.request.Request(f'{base_url}{query}?lock={i+10}')
        res = urllib.request.urlopen(req)
        final_url = res.geturl()
        final_lines.append(f"\"{title}\": \"{final_url}\",")
        print(f"Got {title}")
        time.sleep(0.5)
    except Exception as e:
        print(f'Failed {title}: {e}')
        final_lines.append(f"\"{title}\": \"https://via.placeholder.com/400x500.png?text=Image+Not+Found\",")

with open('resolved_images.txt', 'w') as f:
    f.write('\n'.join(final_lines))
print('DONE')
