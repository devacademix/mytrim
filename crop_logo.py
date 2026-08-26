from PIL import Image

# Load the original logo
img_path = "Admin_Panel/src/assets/img/brand/big_logo.png"
img = Image.open(img_path)

# Crop to keep only "Your LOGO" (up to x=750, before the "Saundarya" text starts at 768)
cropped_img = img.crop((0, 0, 750, img.height))

# Save the cropped logo back to the brand assets
cropped_img.save(img_path)
print("Logo cropped and saved successfully!")
