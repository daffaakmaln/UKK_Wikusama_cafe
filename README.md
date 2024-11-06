# ukk_kasir

A Flutter POS (Point of Sale) project for Wikusama Cafe. This cashier system supports three types of users: **cashiers**, **managers**, and **admins**. The system is designed to streamline cafe operations, making order management and transaction tracking easier.

## Project Overview

In the Wikusama Cafe POS system:
- The **cashier** handles orders, assigns table numbers for identification, and processes payments in cash.
- The **manager** monitors transaction data.
- The **admin** has overall system access and management privileges.

Customers can make additional orders by returning to the cashier, where their data can be updated. Payment is made before customers leave the cafe.

## Features

- **Order Management:** Cashiers can manage orders, assign table numbers, and track customer orders.
- **User Roles:** Distinct permissions and capabilities for cashiers, managers, and admins.
- **Transaction Monitoring:** Managers can view and analyze transaction data.
- **Offline-first Design:** Ensures minimal data requirements.
- **Table Numbering System:** Helps waiters quickly locate the correct tables.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:
- [Flutter SDK](https://docs.flutter.dev/get-started/install): The Flutter Software Development Kit (SDK) allows you to create and run Flutter applications.
- Dart version compatible with Flutter SDK.
- A recent version of [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/): These integrated development environments (IDEs) provide essential tools for building and testing the app.

### Installation

To set up the project on your local machine:

1. **Clone this repository**:
   ```bash
   git clone https://github.com/your-username/ukk_kasir.git
   cd ukk_kasir
