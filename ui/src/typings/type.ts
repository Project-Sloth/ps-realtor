import type { ComponentType } from "svelte";

export interface Tab {
    name: string;
    icon: string;
    component?: ComponentType;
    action?: () => void;
}

type coords = {
    x: number;
    y: number;
    z: number;
}

interface door extends coords {
    h: number;
    length: number;
    width: number;
    count?: number;
    locked?: boolean;
}

type img = {
    url: string;
    label: string;
}

export interface Property {
    property_id: number;
    label?: string;
    owner?: string;
    street?: string;
    region?: string;
    description: string;
    shell: string;
    extra_imgs: img[];
    for_sale: number | boolean;
    price: number;
    door_data: door;
    garage_data: coords | null;
    apartment: string;
}

export interface Apartment {
    apartmentData: {
        label: string;
        door: door;
        imgs: img[];
    }
    apartments: string[];
}
