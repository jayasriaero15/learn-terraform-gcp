from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'manigandan',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='hello_composer_dag',
    default_args=default_args,
    description='Simple learning DAG',
    schedule_interval='@daily',   # runs once per day
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['learning'],
) as dag:

    task1 = BashOperator(
        task_id='print_hello',
        bash_command='echo "Hello from Composer DAG!"'
    )

    task2 = BashOperator(
        task_id='print_date',
        bash_command='date'
    )

    task1 >> task2
