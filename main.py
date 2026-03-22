import luigi
import pandas as pd
from sqlalchemy import create_engine, inspect
from dotenv import load_dotenv
import os

load_dotenv()

class ExtractAndLoadTask(luigi.Task):
    def run(self):
        # Koneksi
        src_engine = create_engine(f"postgresql://{os.getenv('SRC_POSTGRES_USER')}:{os.getenv('SRC_POSTGRES_PASSWORD')}@{os.getenv('SRC_POSTGRES_HOST')}:{os.getenv('SRC_POSTGRES_PORT')}/{os.getenv('SRC_POSTGRES_DB')}")
        dwh_engine = create_engine(f"postgresql://{os.getenv('DWH_POSTGRES_USER')}:{os.getenv('DWH_POSTGRES_PASSWORD')}@{os.getenv('DWH_POSTGRES_HOST')}:{os.getenv('DWH_POSTGRES_PORT')}/{os.getenv('DWH_POSTGRES_DB')}")

        # OTOMATIS: Ambil semua nama tabel yang ada di source
        inspector = inspect(src_engine)
        tables = inspector.get_table_names()
        print(f"Tabel yang ditemukan di sumber: {tables}")

        for table in tables:
            try:
                print(f"Sedang memindahkan tabel: {table}...")
                df = pd.read_sql(f"SELECT * FROM {table}", src_engine)
                # Load ke schema 'pactravel' di DWH
                df.to_sql(table, dwh_engine, schema='pactravel', if_exists='replace', index=False)
                print(f"Selesai: {table} sukses dipindahkan!")
            except Exception as e:
                print(f"Gagal memindahkan {table}: {e}")

    def output(self):
        return []

if __name__ == "__main__":
    luigi.build([ExtractAndLoadTask()], local_scheduler=True)