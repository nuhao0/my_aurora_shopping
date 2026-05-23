import urllib.request
import re
import urllib.parse
import time

queries = [
    # WOMEN
    ('elegant evening gown formal wear model', 'Elegant Evening Gown'),
    ('casual spring dress fashion clothing', 'Casual Spring Dress'),
    ('office blazer women fashion', 'Office Blazer'),
    ('floral skirt summer fashion', 'Summer Floral Skirt'),
    ('cozy winter sweater clothes', 'Cozy Winter Sweater'),
    # MEN
    ('classic formal suit men', 'Classic Formal Suit'),
    ('casual denim shirt men clothes', 'Casual Denim Shirt'),
    ('leather jacket men clothing', 'Leather Jacket'),
    ('summer shorts men fashion', 'Summer Shorts'),
    ('cotton polo shirt men', 'Cotton Polo Shirt'),
    # KIDS
    ('cute dinosaur onesie baby', 'Cute Dinosaur Onesie'),
    ('kids denim overalls', 'Kids Denim Overalls'),
    ('princess party dress girls', 'Princess Party Dress'),
    ('boys winter coat jacket', 'Boys Winter Coat'),
    ('colorful rain boots kids', 'Colorful Rain Boots'),
    # SHOES
    ('pro running sneakers shoes', 'Pro Running Sneakers'),
    ('classic canvas trainers shoes', 'Classic Canvas Trainers'),
    ('leather oxford shoes mens', 'Leather Oxford Shoes'),
    ('summer beach sandals footwear', 'Summer Beach Sandals'),
    ('winter hiking boots shoes', 'Winter Hiking Boots'),
    # BEAUTY
    ('luxury lipstick set makeup', 'Luxury Lipstick Set'),
    ('organic face serum skincare', 'Organic Face Serum'),
    ('designer perfume bottle', 'Designer Perfume'),
    ('eyeshadow palette makeup', 'Eyeshadow Palette'),
    ('complete makeup brush set', 'Complete Brush Set'),
    # GLASSES
    ('aviator sunglasses eyewear', 'Aviator Sunglasses'),
    ('retro round frames glasses', 'Retro Round Frames'),
    ('sport polarized glasses eyewear', 'Sport Polarized Glasses'),
    ('oversized cat eye sunglasses', 'Oversized Cat-Eye'),
    ('blue light blockers glasses', 'Blue Light Blockers'),
    # BAGS
    ('premium leather tote bag', 'Premium Leather Tote'),
    ('canvas backpack bag', 'Canvas Backpack'),
    ('evening party clutch purse', 'Evening Party Clutch'),
    ('crossbody messenger bag', 'Crossbody Messenger'),
    ('minimalist leather wallet', 'Minimalist Wallet'),
    # JACKETS
    ('classic denim jacket clothing', 'Classic Denim Jacket'),
    ('winter puffer jacket warm', 'Winter Puffer Jacket'),
    ('leather biker jacket fashion', 'Leather Biker Jacket'),
    ('light windbreaker jacket', 'Light Windbreaker'),
    ('wool trench coat fashion', 'Wool Trench Coat'),
    # ACCESSORIES
    ('gold necklace jewelry', 'Gold Necklace'),
    ('classic wristwatch leather', 'Classic Wristwatch'),
    ('pearl earrings jewelry', 'Pearl Earrings'),
    ('silk scarf aesthetic', 'Silk Scarf'),
    ('leather belt menswear', 'Leather Belt'),
    # HOME
    ('modern living room sofa', 'Modern Living Sofa'),
    ('ceramic coffee mug', 'Ceramic Coffee Mug'),
    ('cozy throw blanket home', 'Cozy Throw Blanket'),
    ('indoor plant pot decoration', 'Indoor Plant Pot'),
    ('minimalist wall clock home', 'Minimalist Wall Clock'),
]

final_out = []

for q, title in queries:
    url = 'https://www.bing.com/images/search?q=' + urllib.parse.quote(q)
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
        html = urllib.request.urlopen(req).read().decode('utf-8')
        matches = re.findall(r'https://tse[0-9]\.mm\.bing\.net/th/id/[a-zA-Z0-9.-]+', html)
        if matches:
            img = matches[0] + '?pid=Api&w=400&h=500&c=7'
            final_out.append(f'      {{"title": "{title}", "image": "{img}"}},')
            print("Found Bing:", title, img)
        else:
            final_out.append(f'      {{"title": "{title}", "image": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}"}},')
            print("Not found:", title)
    except Exception as e:
        final_out.append(f'      {{"title": "{title}", "image": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}"}},')
        print("Exception:", title)
    time.sleep(0.3)

with open('resolved_images_bing.txt', 'w') as f:
    f.write('\n'.join(final_out))
print("DONE BING")
