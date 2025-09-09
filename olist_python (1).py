# Importar librerías
from faker import Faker
from faker.providers import internet, person
import unicodedata

# Crear una instancia de Faker con localización brasileña
fake = Faker('pt_BR')
fake.add_provider(person)  # Proveedor para First Name y Last Name
fake.add_provider(internet)  # Proveedor para datos de Internet


# Función para generar un número de teléfono en formato internacional para Brasil
def generate_brazilian_phone():
    area_code = fake.random_int(min=11, max=99)  # Códigos de área brasileños
    phone_number = fake.numerify('#####-####')  # Número de 9 dígitos
    return f"+55 ({area_code}) {phone_number}"


# Función para eliminar caracteres especiales (acentos, ñ, etc.)
def remove_special_characters(name):
    # Normalizar el texto y eliminar los acentos
    name_normalized = unicodedata.normalize('NFKD', name)
    return ''.join([c for c in name_normalized if not unicodedata.combining(c)])


# Lista de dominios más comunes para emails
email_domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com', 'empresa.com']

# Función para generar un email más realista
def generate_realistic_email(first_name, last_name):
    domain = fake.random_element(email_domains)  # Selecciona un dominio aleatorio
    # Eliminar los espacios y caracteres especiales
    username = f"{first_name.lower().replace(' ', '').replace('_', '')}.{last_name.lower().replace(' ', '').replace('_', '')}"  # Eliminar espacios y caracteres
    return f"{username}@{domain}"

# Función para generar datos de usuario con el número especificado de usuarios.
def generate_user_data(num_of_users):
   # Inicializar una lista vacía para almacenar los datos de los usuarios.
   user_data = []
   # Bucle para generar datos para el número especificado de usuarios.
   for _ in range(num_of_users):
        first_name = fake.first_name()
        last_name = fake.last_name()

        # Eliminar caracteres especiales de los nombres
        first_name_clean = remove_special_characters(first_name)
        last_name_clean = remove_special_characters(last_name)
       
        # Crear un diccionario representando un usuario con varios atributos.
        user = {
            'first_name': first_name_clean,
            'last_name': last_name_clean,
            'email': generate_realistic_email(first_name_clean, last_name_clean),  # Generar email realista
            'phone_number': generate_brazilian_phone(),
            }
        # Añadir el diccionario de datos del usuario a la lista de usuarios.
        user_data.append(user)
   # Devolver la lista de datos de usuarios generados.
   return user_data


import pandas as pd
file_path = r"C:\Users\gisel\OneDrive\Documentos\Data\Unicorn\Proyecto\Olist\olist_customers_dataset.csv"
df= pd.read_csv(file_path)

new_data= generate_user_data(len(df))

new_columns_df = pd.DataFrame(new_data)

updated_df = pd.concat([df, new_columns_df], axis=1)

output_path = r"C:\Users\gisel\OneDrive\Documentos\Data\Unicorn\Proyecto\Olist\customers_dataset_actualizado.csv" 
updated_df.to_csv(output_path, index=False)

print(f"Datos actualizados guardados en: {output_path}")