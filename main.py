from datetime import datetime
from typing import List, Dict, Any

import uvicorn
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, String, DateTime, Integer, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
import json

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, index=True)
    firstName = Column(String, index=True)
    lastName = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    appointments = relationship("ServiceBar", back_populates="user")

class ServiceBar(Base):
    __tablename__ = 'servicebars'
    id = Column(Integer, primary_key=True, index=True)
    userEmail = Column(String, ForeignKey('users.email'))
    services = Column(String)
    appointmentDate = Column(DateTime)
    user = relationship("User", back_populates="appointments")

class UserCreate(BaseModel):
    firstName: str
    lastName: str
    email: str
    password: str
    selectedServices: List[Dict[str, Any]]

    @classmethod
    def from_dict(cls, data: Dict[str, Any]):
        services_data = data.get('selectedServices', [])
        services = [ServiceBarCreate(**s) for s in services_data]
        return cls(firstName=data.get('firstName', ''), lastName=data.get('lastName', ''),
                   email=data.get('email', ''), password=data.get('password', ''), selectedServices=services)

    def to_dict(self):
        return {
            'firstName': self.firstName,
            'lastName': self.lastName,
            'email': self.email,
            'password': self.password,
            'selectedServices': [s.to_dict() for s in self.selectedServices]
        }

class ServiceBarCreate(BaseModel):
    userEmail: str
    services: List[str]
    appointmentDate: datetime

    def to_dict(self):
        return {
            'userEmail': self.userEmail,
            'services': json.dumps(self.services),
            'appointmentDate': self.appointmentDate.isoformat()
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]):
        services = json.loads(data.get('services', '[]'))
        return cls(userEmail=data['userEmail'], services=services,
                   appointmentDate=datetime.fromisoformat(data['appointmentDate']))

SQLALCHEMY_DATABASE_URL = 'sqlite:///example.db'
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

app = FastAPI()

@app.on_event("startup")
def startup_event():
    Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/users/")
def save_user(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user.email).first()

    if existing_user:
        # Оновлення існуючих даних користувача
        existing_user.firstName = user.firstName
        existing_user.lastName = user.lastName
        existing_user.password = user.password

        # Видалення старих записів про послуги користувача
        db.query(ServiceBar).filter(ServiceBar.userEmail == user.email).delete()
    else:
        # Створення нового користувача
        existing_user = User(
            firstName=user.firstName,
            lastName=user.lastName,
            email=user.email,
            password=user.password,
        )
        db.add(existing_user)

    # Додавання нових записів про послуги користувача
    for service in user.selectedServices:
        # Парсинг дати в форматі ISO 8601 із мілісекундами
        appointment_date = datetime.strptime(service.get('appointmentDate'), '%Y-%m-%dT%H:%M:%S.%f')

        db_service = ServiceBar(
            userEmail=user.email,
            services=json.dumps(service['services']),
            appointmentDate=appointment_date,
        )
        db.add(db_service)

    db.commit()
    return {"message": "User saved successfully"}


@app.get("/users/{email}")
def get_user_by_email(email: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    services = db.query(ServiceBar).filter(ServiceBar.userEmail == email).all()
    selected_services = [{"userEmail":s.userEmail, "id": s.id, "services": s.services, "appointmentDate": s.appointmentDate.isoformat()} for s in services]
    return {
        "id": user.id,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "password": user.password,
        "email": user.email,
        "selectedServices": services
    }

@app.post("/servicebars/")
def create_service_bar(servicebar: ServiceBarCreate, db: Session = Depends(get_db)):
    services_json = json.dumps(servicebar.services)
    db_servicebar = ServiceBar(userEmail=servicebar.userEmail, services=services_json, appointmentDate=servicebar.appointmentDate)
    db.add(db_servicebar)
    db.commit()
    return {"message": "ServiceBar created successfully"}


@app.get("/users/{email}/services/")
def get_selected_services(email: str, db: Session = Depends(get_db)):
    # Перевірка, чи існує користувач
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Отримання всіх сервісів, пов'язаних з цим користувачем
    services = db.query(ServiceBar).filter(ServiceBar.userEmail == email).all()

    return services


@app.post("/servicebars/")
def create_service_bar(servicebar: ServiceBarCreate, db: Session = Depends(get_db)):
    services_json = json.dumps(servicebar.services)
    db_servicebar = ServiceBar(userEmail=servicebar.userEmail, services=services_json, appointmentDate=servicebar.appointmentDate)
    db.add(db_servicebar)
    db.commit()
    return {"message": "ServiceBar created successfully"}

@app.delete("/servicebars/{service_id}")
def delete_service_bar(service_id: int, db: Session = Depends(get_db)):
    service = db.query(ServiceBar).filter(ServiceBar.id == service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Service not found")
    db.delete(service)
    db.commit()
    return {"message": "ServiceBar deleted successfully"}
uvicorn.run(app)