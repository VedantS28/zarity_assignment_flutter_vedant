import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import uuid
import random
from faker import Faker

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Initialize Firebase Admin with relative path
cred = credentials.Certificate(os.path.join(script_dir, 'zarity-assignment-vedant-iiit-firebase-adminsdk-fbsvc-7ed684a94c.json'))
firebase_admin.initialize_app(cred)

db = firestore.client()
fake = Faker()

# Health-related topics and keywords
HEALTH_TOPICS = [
    'nutrition', 'exercise', 'mental-health', 'wellness', 'meditation',
    'yoga', 'healthy-eating', 'fitness', 'weight-management', 'sleep'
]

def get_random_image():
    """Get a random image URL from Lorem Picsum"""
    # Lorem Picsum provides random images with specific width/height
    width = random.choice([600, 800, 1000])
    height = random.choice([400, 500, 600])
    # Adding random id to prevent duplicate images
    random_id = random.randint(1, 1000)
    return f"https://picsum.photos/id/{random_id}/{width}/{height}"

def generate_health_title():
    """Generate health-related blog titles"""
    templates = [
        f"{random.randint(5,20)} Essential {fake.word().title()} Tips for Better Health",
        f"The Complete Guide to {fake.word().title()} for Optimal Wellness",
        f"Understanding {fake.word().title()}: A Comprehensive Health Guide",
        f"How to Improve Your {fake.word().title()} Naturally",
        f"The Science Behind {fake.word().title()} and Your Health",
        f"Natural Ways to Boost Your {fake.word().title()}",
        f"The Connection Between {fake.word().title()} and {fake.word().title()}",
        f"Daily {fake.word().title()} Habits for Better Health"
    ]
    return random.choice(templates)

def generate_health_content():
    """Generate health-related blog content"""
    health_paragraphs = []
    topics = [
        "It's important to note that before starting any new health routine, consulting with a healthcare professional is recommended.",
        f"Recent studies have shown that {fake.word()} can significantly impact your overall well-being.",
        "Regular exercise and proper nutrition play crucial roles in maintaining optimal health.",
        f"Understanding the connection between {fake.word()} and wellness is essential.",
        "Maintaining a balanced lifestyle involves both physical and mental health practices.",
        f"Experts recommend incorporating {fake.word()} into your daily routine for better health outcomes.",
        "A holistic approach to health includes both preventive measures and active lifestyle choices.",
        f"The benefits of {fake.word()} extend beyond physical health to mental and emotional well-being."
    ]
    
    # Mix predefined health topics with generated content
    health_paragraphs.extend(topics)
    health_paragraphs.extend([fake.paragraph(nb_sentences=4) for _ in range(3)])
    random.shuffle(health_paragraphs)
    
    return '\n\n'.join(health_paragraphs)

def generate_blog_post():
    """Generate a single health-focused blog post"""
    blog_id = str(uuid.uuid4())
    topic = random.choice(HEALTH_TOPICS)
    
    return {
        'id': blog_id,
        'imageURL': get_random_image(),
        'title': generate_health_title(),
        'summary': fake.paragraph(nb_sentences=2),
        'content': generate_health_content(),
        'deeplink': f"https://vite-react-ten-tau-59.vercel.app/post/{blog_id}",
        'topic': topic,
        'readTime': f"{random.randint(3, 15)} min read",
        'publishDate': fake.date_between(start_date='-1y', end_date='today').isoformat(),
        'tags': [topic, 'health', 'wellness', random.choice(HEALTH_TOPICS)]
    }

def batch_upload_blogs(num_posts=50):
    """Upload multiple blog posts in batches"""
    batch_size = 500  # Firestore batch limit
    blog_posts = []
    
    # Generate all blog posts
    for _ in range(num_posts):
        blog_posts.append(generate_blog_post())
    
    # Upload in batches
    for i in range(0, len(blog_posts), batch_size):
        batch = db.batch()
        current_batch = blog_posts[i:i + batch_size]
        
        for post in current_batch:
            doc_ref = db.collection('blog_posts').document(post['id'])
            batch.set(doc_ref, post)
        
        batch.commit()
        print(f"Uploaded batch of {len(current_batch)} posts")

if __name__ == "__main__":
    try:
        # Generate and upload 50 blog posts
        batch_upload_blogs(50)
        print("Successfully uploaded all blog posts!")
    except Exception as e:
        print(f"Error uploading blog posts: {e}")