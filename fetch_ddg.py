import urllib.request
import re
import time
import urllib.parse

queries = [
    # WOMEN
    ('elegant evening gown formal wear pexels', 'Elegant Evening Gown'),
    ('casual spring dress clothing pexels', 'Casual Spring Dress'),
    ('office blazer women fashion pexels', 'Office Blazer'),
    ('floral skirt summer fashion pexels', 'Summer Floral Skirt'),
    ('cozy winter sweater clothes pexels', 'Cozy Winter Sweater'),
    # MEN
    ('classic formal suit men pexels', 'Classic Formal Suit'),
    ('casual denim shirt men clothes pexels', 'Casual Denim Shirt'),
    ('leather jacket men clothing pexels', 'Leather Jacket'),
    ('summer shorts men fashion pexels', 'Summer Shorts'),
    ('cotton polo shirt men pexels', 'Cotton Polo Shirt'),
    # KIDS
    ('cute dinosaur onesie baby pexels', 'Cute Dinosaur Onesie'),
    ('kids denim overalls pexels', 'Kids Denim Overalls'),
    ('princess party dress girls pexels', 'Princess Party Dress'),
    ('boys winter coat jacket pexels', 'Boys Winter Coat'),
    ('colorful rain boots kids pexels', 'Colorful Rain Boots'),
    # SHOES
    ('pro running sneakers shoes pexels', 'Pro Running Sneakers'),
    ('classic canvas trainers shoes pexels', 'Classic Canvas Trainers'),
    ('leather oxford shoes mens pexels', 'Leather Oxford Shoes'),
    ('summer beach sandals footwear pexels', 'Summer Beach Sandals'),
    ('winter hiking boots shoes pexels', 'Winter Hiking Boots'),
    # BEAUTY
    ('luxury lipstick set makeup pexels', 'Luxury Lipstick Set'),
    ('organic face serum skincare pexels', 'Organic Face Serum'),
    ('designer perfume bottle pexels', 'Designer Perfume'),
    ('eyeshadow palette makeup pexels', 'Eyeshadow Palette'),
    ('complete makeup brush set pexels', 'Complete Brush Set'),
    # GLASSES
    ('aviator sunglasses eyewear pexels', 'Aviator Sunglasses'),
    ('retro round frames glasses pexels', 'Retro Round Frames'),
    ('sport polarized glasses eyewear pexels', 'Sport Polarized Glasses'),
    ('oversized cat eye sunglasses pexels', 'Oversized Cat-Eye'),
    ('blue light blockers glasses pexels', 'Blue Light Blockers'),
    # BAGS
    ('premium leather tote bag pexels', 'Premium Leather Tote'),
    ('canvas backpack bag pexels', 'Canvas Backpack'),
    ('evening party clutch purse pexels', 'Evening Party Clutch'),
    ('crossbody messenger bag pexels', 'Crossbody Messenger'),
    ('minimalist leather wallet pexels', 'Minimalist Wallet'),
    # JACKETS
    ('classic denim jacket clothing pexels', 'Classic Denim Jacket'),
    ('winter puffer jacket warm pexels', 'Winter Puffer Jacket'),
    ('leather biker jacket fashion pexels', 'Leather Biker Jacket'),
    ('light windbreaker jacket pexels', 'Light Windbreaker'),
    ('wool trench coat fashion pexels', 'Wool Trench Coat'),
    # ACCESSORIES
    ('gold necklace jewelry pexels', 'Gold Necklace'),
    ('classic wristwatch leather pexels', 'Classic Wristwatch'),
    ('pearl earrings jewelry pexels', 'Pearl Earrings'),
    ('silk scarf aesthetic pexels', 'Silk Scarf'),
    ('leather belt menswear pexels', 'Leather Belt'),
    # HOME
    ('modern living room sofa pexels', 'Modern Living Sofa'),
    ('ceramic coffee mug pexels', 'Ceramic Coffee Mug'),
    ('cozy throw blanket home pexels', 'Cozy Throw Blanket'),
    ('indoor plant pot decoration pexels', 'Indoor Plant Pot'),
    ('minimalist wall clock home pexels', 'Minimalist Wall Clock'),
]

final_out = []
for q, title in queries:
    url = 'https://html.duckduckgo.com/html/?q=' + urllib.parse.quote(q)
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
        html = urllib.request.urlopen(req).read().decode('utf-8')
        matches = re.findall(r'//external-content\.duckduckgo\.com/iu/\?u=(.*?)&', html)
        if matches:
            img = urllib.parse.unquote(matches[0])
            final_out.append(f'        "{title}": "{img}",')
            print("Found Duck:", title)
        else:
            final_out.append(f'        "{title}": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}",')
            print("Not found:", title)
    except Exception as e:
        final_out.append(f'        "{title}": "https://placehold.co/400x500/EAEAEA/31343C?text={title.replace(" ", "+")}",')
        print("Exception:", title)
    time.sleep(0.5)

with open('resolved_images_ddg.txt', 'w') as f:
    f.write('\n'.join(final_out))
print("DONE DDG")
