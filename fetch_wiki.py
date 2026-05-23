import urllib.request
import json
import urllib.parse
import time

queries = [
    # WOMEN
    ('Evening Gown Fashion', 'Elegant Evening Gown'),
    ('Spring Dress Woman', 'Casual Spring Dress'),
    ('Womens Office Blazer', 'Office Blazer'),
    ('Women Skirt', 'Summer Floral Skirt'),
    ('Women Winter Sweater', 'Cozy Winter Sweater'),
    # MEN
    ('Formal Suit Man', 'Classic Formal Suit'),
    ('Denim Shirt Man', 'Casual Denim Shirt'),
    ('Black Leather Jacket Man', 'Leather Jacket'),
    ('Summer Shorts Man', 'Summer Shorts'),
    ('Polo Shirt Man', 'Cotton Polo Shirt'),
    # KIDS
    ('Toddler onesie', 'Cute Dinosaur Onesie'),
    ('Kids overalls', 'Kids Denim Overalls'),
    ('Girl party dress', 'Princess Party Dress'),
    ('Boys winter coat', 'Boys Winter Coat'),
    ('Kids rain boots', 'Colorful Rain Boots'),
    # SHOES
    ('Running sneakers', 'Pro Running Sneakers'),
    ('Canvas Trainers Shoes', 'Classic Canvas Trainers'),
    ('Leather Oxford Shoes', 'Leather Oxford Shoes'),
    ('Beach Sandals', 'Summer Beach Sandals'),
    ('Winter Hiking Boots', 'Winter Hiking Boots'),
    # BEAUTY
    ('Lipstick makeup product', 'Luxury Lipstick Set'),
    ('Face Serum Bottle', 'Organic Face Serum'),
    ('Perfume Bottle Glass', 'Designer Perfume'),
    ('Eyeshadow Palette Makeup', 'Eyeshadow Palette'),
    ('Makeup Brushes set', 'Complete Brush Set'),
    # GLASSES
    ('Aviator Sunglasses', 'Aviator Sunglasses'),
    ('Round Glasses Retro', 'Retro Round Frames'),
    ('Polarized Sunglasses Sport', 'Sport Polarized Glasses'),
    ('Cat Eye Sunglasses', 'Oversized Cat-Eye'),
    ('Blue Light Glasses', 'Blue Light Blockers'),
    # BAGS
    ('Leather Tote Bag', 'Premium Leather Tote'),
    ('Canvas Backpack', 'Canvas Backpack'),
    ('Evening Clutch Bag', 'Evening Party Clutch'),
    ('Messenger Bag Leather', 'Crossbody Messenger'),
    ('Leather Wallet Minimalist', 'Minimalist Wallet'),
    # JACKETS
    ('Denim Jacket', 'Classic Denim Jacket'),
    ('Puffer Jacket Winter', 'Winter Puffer Jacket'),
    ('Biker Jacket Leather', 'Leather Biker Jacket'),
    ('Windbreaker Jacket', 'Light Windbreaker'),
    ('Trench Coat Wool', 'Wool Trench Coat'),
    # ACCESSORIES
    ('Gold Necklace Jewelry', 'Gold Necklace'),
    ('Wristwatch Leather', 'Classic Wristwatch'),
    ('Pearl Earrings Jewelry', 'Pearl Earrings'),
    ('Silk Scarf Women', 'Silk Scarf'),
    ('Leather Belt Men', 'Leather Belt'),
    # HOME
    ('Living Room Sofa Modern', 'Modern Living Sofa'),
    ('Ceramic Coffee Mug', 'Ceramic Coffee Mug'),
    ('Throw Blanket Cozy', 'Cozy Throw Blanket'),
    ('Indoor Plant Pot Home', 'Indoor Plant Pot'),
    ('Wall Clock Minimalist', 'Minimalist Wall Clock'),
]

final_out = []

for q, title in queries:
    try:
        url = 'https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=thumbnail&pithumbsize=500&generator=search&gsrsearch=' + urllib.parse.quote(q) + '&gsrlimit=1'
        req = urllib.request.Request(url, headers={'User-Agent': 'TaqikrdnawaBot/1.0'})
        res = urllib.request.urlopen(req).read()
        data = json.loads(res.decode('utf-8'))
        pages = data.get('query', {}).get('pages', {})
        img_url = ''
        for k, v in pages.items():
            if 'thumbnail' in v:
                img_url = v['thumbnail']['source']
                break
        
        if img_url:
            final_out.append(f'"{title}": "{img_url}",')
            print("Found:", title)
        else:
            print("Not found (empty):", title)
            final_out.append(f'"{title}": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}",')
    except Exception as e:
        print("Error", title, str(e))
        final_out.append(f'"{title}": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}",')
        
    time.sleep(0.1)

with open('resolved_images.txt', 'w') as f:
    f.write('\n'.join(final_out))
print("DONE WIKI")
