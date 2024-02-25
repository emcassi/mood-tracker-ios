import pandas as pd
import numpy as np
import sqlite3


def prepare_hotlines():
    csv_file_path = '~/Documents/hotlines.csv'
    df = pd.read_csv(csv_file_path)

    conditions = [
    df['is_youth_hotline'],
    df['is_general_hotline'],
    df['is_womens_hotline'],
    df['is_lgbtq_hotline'],
    df['is_veterans_hotline'],
    df['is_trans_hotline']
]

    # Define the choices corresponding to each condition
    choices = ['Youth', 'General', 'Womens', 'LGBTQ', 'Trans', 'Veterans']

    # Use numpy.select to apply conditions and choices
    df['type'] = np.select(conditions, choices, default='General')


    df = df.drop(columns=['is_veterans_hotline', 'is_lgbtq_hotline', 'is_youth_hotline', 'is_womens_hotline', 'is_trans_hotline', 'is_general_hotline'])
    return df

def prepare_countries():
    csv_file_path = '~/Documents/countries.csv'
    df = pd.read_csv(csv_file_path)
    df = df.rename(columns={'country': 'name'})
    return df


hotlines_df = prepare_hotlines()

# country_df = prepare_countries()

database_path = 'mudi.sqlite'
conn = sqlite3.connect(database_path)

hotlines_df.to_sql('hotlines', conn, if_exists='replace', index=True)
# country_df.to_sql('countries', conn, if_exists='replace', index=True)

conn.close()
