# Galaxy Tech

## Introduction

Welcome to Galaxy Tech, an e-commerce platform dedicated to selling PC parts, components and phones. 
It offers a wide range of products from CPUs and GPUs to RAM and SSDs. Whether you're 
building a PC from scratch, upgrading a current setup, or just looking for specific components, Galaxy 
Tech has you covered. The platform features detailed product descriptions and a search 
engine to help you find exactly what you need.

## Live Demo

You can see a live version of the app **[here](https://galaxy-tech.onrender.com)**.
Please note that the app is hosted on a free tier and may take a moment to load if it has been inactive.

## Features

- **User Authentication:** Implemented with Devise gem. Users can sign up, log in, and log out. Passwords are securely 
hashed and stored.

- **Product Catalog:** A wide range of PC components are listed. Each product has a detailed description, price, 
and image.

- **Search and Filter:** Users can search for products by name or filter by categories such as CPUs, GPUs, RAM, 
and SSDs.

- **Shopping Cart:** Users can add products to a shopping cart and adjust quantities as needed.

- **Checkout and Payment:** Integrated with Stripe for payment processing. Users can enter their payment details and 
complete their purchase.

- **Order History:** Users can view their past orders, including the purchased items, quantities, and total cost.

[//]: # (- **Product Reviews:** Users can leave reviews for products they've purchased, including a rating and comments.)

- **Admin Panel:** Admin users can add, edit, or remove products.


## Technology Used

- Ruby on Rails
- Hotwire
- PostgreSQL
- Devise
- Active Storage
- TailwindCSS
- Cloudinary

[//]: # (## Screenshots)

[//]: # ()
[//]: # (![SS1]&#40;./app/assets/images/ss1.PNG&#41;)

[//]: # (![SS2]&#40;./app/assets/images/ss2.PNG&#41;)

[//]: # (![GIF1]&#40;./app/assets/images/chatting_gif.gif&#41;)


## Future Features

- UI/UX improvement
- Admin can manage and view all users orders and the site content.
- Rating and review for each product.
- Email service for new user sign up, password reset, email confirmation, order confirmation.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have Ruby and Rails installed on your machine. See [this guide](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails) for instructions on setting up Rails.

### Installing

1. Clone the repository: `git clone https://github.com/DiptoSarkar182/galaxy_tech`
2. Navigate into the project directory: `cd galaxy_tech`
3. Install the dependencies: `bundle install`
4. Set up the database: `rails db:create db:migrate`
5. Start the server: `rails server`
6. Visit `http://localhost:3000/` in your browser to access the application.


- <a target="_blank" href="https://icons8.com/icon/59997/shopping-cart">Cart, <a target="_blank" href="https://icons8.com/icon/65342/customer">Customer</a>
</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>

